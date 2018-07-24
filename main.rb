     
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
require_relative 'models/userevent'
enable :sessions

get '/' do
  erb :index
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

  info['events']['data'].each {|event|
    if !!event['place'] && !!event['place']['name'] && Place.find_by(name: event['place']['name']) == nil && Place.find_by(fb_id: event['place']['id'].to_i) == nil
      new_place = Place.new
      if !!event['place']['name']
        new_place.name = event['place']['name']
      end
      if !!event['place']['location']
        if !!event['place']['location']['city']
          new_place.city = event['place']['location']['city']
        end
        if !!event['place']['location']['state']
          new_place.state = event['place']['location']['state']
        end
        if !!event['place']['location']['street']
          new_place.street = event['place']['location']['street']
        end
        if !!event['place']['location']['country']
          new_place.country = event['place']['location']['country']
        end
        if !!event['place']['location']['zip'].to_i
          new_place.zip = event['place']['location']['zip'].to_i
        end
        if !!event['place']['location']['latitude']
          new_place.latitude = event['place']['location']['latitude']
        end
        if !!event['place']['location']['longitude']
          new_place.longitude = event['place']['location']['longitude']
        end
      end
      if !!event['place']['id']
        new_place.fb_id = event['place']['id'].to_i
      end

      new_place.save
      # to be implemented with facebook review
      # new_place.logo = HTTParty.get("https://graph.facebook.com/#{event['place']['id']}?fields=cover&access_token=#{params[:access_token]}")
    end

    if Event.find_by(fb_id: event['id']) == nil
      new_event = Event.new
      new_event.name = event['name']

      new_event.image_url = HTTParty.get("https://graph.facebook.com/#{event['id']}?fields=cover&access_token=#{params[:access_token]}")['cover']['source']
      if !!event['place'] && Place.find_by(fb_id: event['place']['id']) != nil
        new_event.place_id = Place.find_by(fb_id: event['place']['id']).id.to_i
      end
      new_event.fb_id = event['id']
      new_event.description = event['description']
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


  
  # image fetch
  # HTTParty.get("https://graph.facebook.com/1734531426666686?fields=cover&access_token=#{params[:access_token]}")
  # "https://graph.facebook.com/#{event_id}?fields=cover&access_token=#{params[:access_token]}"
  redirect '/success'
end

get '/success' do
  return 'yaay'
end

