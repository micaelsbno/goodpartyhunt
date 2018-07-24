# pry session with your data models loaded

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
require_relative 'models/user_event'

binding.pry