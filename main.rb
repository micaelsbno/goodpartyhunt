     
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/category'
require_relative 'models/event_category'
require_relative 'models/place'
require_relative 'models/user_event'
require_relative 'models/event'
require_relative 'models/event_time'
require_relative 'models/user_sessions'
require_relative 'helpers/database'
enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

end


get '/search' do
  @events = Event.all
  @user_latitude = current_user.latitude.to_f
  @user_longitude = current_user.longitude.to_f
  @radius = (current_user.radius.to_f / 100000) / 1.2
  erb :search
end

post '/search' do
  binding.pry
  Database.add_user_rsvp(current_user, Event.find(params[:event_id], "attending"))
  redirect '/search'
end

get '/' do
  if logged_in?

    @user_latitude = current_user.latitude.to_f
    @user_longitude = current_user.longitude.to_f
    @events = current_user.events
    @radius = (current_user.radius.to_f / 100000) / 1.2
    erb :index
  else
    redirect '/login'
  end
end

post '/info' do
  @info = HTTParty.get("https://graph.facebook.com/v3.0/me?fields=id%2Cname%2Cfriends%2Cpicture%2Cemail%2Cevents&access_token=#{params[:access_token]}")
  @access_token = params[:access_token]
  Database.add_user(@info)
  @info['events']['data'].each { |event|
    Database.add_place(event)
    Database.add_event(event, @access_token, @info)
  }
  session[:user_id] = User.find_by(fb_id: @info['id']).id
  Database.add_user_session(current_user.id)
  if current_user.user_sessions.count > 1
    redirect '/'
  else
  redirect '/welcome'
  end
end

get '/welcome' do
  erb :welcome
end

put '/location' do
  user = current_user
  user.latitude = params[:latitude].to_f
  user.longitude = params[:longitude].to_f
  user.radius = params[:radius]
  user.save
  redirect '/search'
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

get '/login' do
  erb :login
end


put '/start' do
  user = current_user
  user.latitude = params[:latitude].to_f
  user.longitude = params[:longitude].to_f
  user.radius = params[:radius]
  user.save
  redirect '/'
end

