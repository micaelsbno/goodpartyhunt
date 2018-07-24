require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'partyhunting_db'
}

ActiveRecord::Base.establish_connection(options)