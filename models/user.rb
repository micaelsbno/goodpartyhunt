class User < ActiveRecord::Base
  has_many :user_events
  has_many :events
  has_many :user_categories
end