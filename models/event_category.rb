class Event_category < ActiveRecord::Base
  has_many :users
  has_many :events
  has_many :categories
  # add a method - password
  # add another method - authentication
end