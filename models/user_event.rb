class User_event < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :events
end