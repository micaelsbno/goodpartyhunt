class Database
  def self.add_user(info)
    if User.find_by(fb_id: info['id']) == nil
    user = User.new
    user.name = info['name']
    user.email = info['email']
    user.profile_pic = info['picture']['data']['url']
    user.fb_id = info['id'].to_i
    user.save
    end
  end

  def self.add_user_session(user_id)
    user_session = UserSession.new
    user_session.user_id = user_id
    user_session.save
  end

  def self.add_place(event)
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
  end

  def self.add_event_times(event)
    if event['event_times'] != nil
        event['event_times'].each { |time|
          new_event_time = EventTime.new
          new_event_time.start_time = time['start_time'].to_time
          new_event_time.end_time = time['end_time'].to_time
          new_event_time.event_id = Event.find_by(fb_id: event['id']).id
          new_event_time.save
        }
      else
        new_event_time = EventTime.new
        new_event_time.start_time = event['start_time']
        new_event_time.end_time = event['end_time']
        new_event_time.event_id = Event.find_by(fb_id: event['id']).id
        new_event_time.save
      end
  end

  def self.add_user_rsvp (info, event)
    user_rsvp = UserEvent.new
    user_rsvp.user_id = User.find_by(fb_id: info['id'].to_i).id
    user_rsvp.event_id = Event.find_by(fb_id: event['id'])['id'].to_i
    user_rsvp.rsvp = event['rsvp_status']
    user_rsvp.save
  end

  def self.add_event(event, access_token, info)
    if Event.find_by(fb_id: event['id']) == nil
      new_event = Event.new
      new_event.image_url = HTTParty.get("https://graph.facebook.com/#{event['id']}?fields=cover&access_token=#{access_token}")['cover']['source']
      
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
      self.add_event_times(event)
      self.add_user_rsvp(info, event)
    end
  end

end