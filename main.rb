     
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
enable :sessions


get '/' do
  erb :index
end

post '/info' do
  info = HTTParty.get("https://graph.facebook.com/v3.0/me?fields=id%2Cname%2Cevents&access_token=#{params[:access_token]}")
  binding.pry

end

# post '/' do
#   user = User.


# end


