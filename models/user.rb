class User < ActiveRecord::Base
  has_many :events, through: :user_events
  has_many :event_categories
  has_many :user_friends
end