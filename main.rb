     
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
enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

end


get '/:radius' do
  redirect '/login' unless logged_in?
  @distance = (params[:radius].to_f / 100000)
  Event.all.each { |event|
    place = event.place
    if !!place.latitude
        if (event.place.latitude.to_f - current_user.latitude.to_f)**2 + (event.place.longitude.to_f - current_user.longitude.to_f)**2 < @distance**2    
          puts event.place
        end
    end
  }
      

  erb :index
end

get '/' do
  redirect '/login' unless logged_in?
  @distance = (@radius.to_f / 100000)
  Event.all.each { |event|
    place = event.place
    if !!place.latitude
        if (event.place.latitude.to_f - current_user.latitude.to_f)**2 + (event.place.longitude.to_f - current_user.longitude.to_f)**2 < @distance**2    
          puts event
        end
    end
    }
      

  erb :index
end

get '/login' do
  erb :login
end

post '/info' do
  info = HTTParty.get("https://graph.facebook.com/v3.0/me?fields=id%2Cname%2Cfriends%2Cpicture%2Cemail%2Cevents&access_token=#{params[:access_token]}")
  if User.find_by(fb_id: info['id']) == nil
    user = User.new
    user.name = info['name']
    user.email = info['email']
    user.profile_pic = info['picture']['data']['url']
    user.fb_id = info['id'].to_i
    user.save
  end

  info['events']['data'].each { |event|
    if !!event['place'] && !!event['place']['name'] && Place.find_by(name: event['place']['name']) == nil && Place.find_by(fb_id: event['place']['id'].to_i) == nil
      new_place = Place.new
      event['place'].each{ |key, value|
        case key
        when 'name'
          new_place.name = value
        when 'id'
          new_place.fb_id = value.to_i
        when 'location'
          value.each { |key,value|
            case key
            when 'city'
              new_place.city = value
            when 'country'
              new_place.country = value
            when 'latitude'
              new_place.latitude = value
            when 'longitude'
              new_place.longitude = value
            when 'state'
              new_place.state = value
            when 'street'
              new_place.street = value
            when 'zip'
              new_place.zip = value.to_i
            else
              'not found' 
            end
          }
        end
        new_place.save
      }
    end
  
    if Event.find_by(fb_id: event['id']) == nil
      new_event = Event.new
      new_event.image_url = HTTParty.get("https://graph.facebook.com/#{event['id']}?fields=cover&access_token=#{params[:access_token]}")['cover']['source']
      
      event.each { |key, value|
        case key
        when 'name'
          new_event.name = value
        when 'place'
          new_event.place_id = Place.find_by(fb_id: value['id']).id.to_i
        when 'id'
          new_event.fb_id = value.to_i
        when 'description'
          new_event.description = value
        else
          'not found'
        end
      }
      new_event.save
       
      if event['event_times'] != nil
        event['event_times'].each { |time|
          new_event_time = Event_time.new
          new_event_time.start_time = time['start_time'].to_time
          new_event_time.end_time = time['end_time'].to_time
          new_event_time.event_id = Event.find_by(fb_id: event['id']).id
          new_event_time.save
        }
      else
        new_event_time = Event_time.new
        new_event_time.start_time = event['start_time']
        new_event_time.end_time = event['end_time']
        new_event_time.event_id = Event.find_by(fb_id: event['id']).id
        new_event_time.save
      end

      user_rsvp = User_event.new
      user_rsvp.user_id = User.find_by(fb_id: info['id'].to_i).id
      user_rsvp.event_id = Event.find_by(fb_id: event['id'])['id'].to_i
      user_rsvp.rsvp = event['rsvp_status']
      user_rsvp.save
      
    end

  }
  session[:user_id] = User.find_by(fb_id: info['id']).id
  redirect '/'
end

put '/search' do
  user = current_user
  user.latitude = params[:latitude].to_f
  user.longitude = params[:longitude].to_f
  user.save
  redirect "/#{params[:radius]}"
end

get '/success' do
  erb :index
end

