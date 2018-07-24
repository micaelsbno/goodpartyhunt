class Event < ActiveRecord::Base
  has_many :user_events
  belongs_to :place
  has_many :event_times
  has_many :categories
  # add a method - password
  # add another method - authentication
end