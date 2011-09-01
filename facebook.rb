require 'sinatra'
require 'oauth'
require 'json'


set :views, File.dirname(__FILE__) + '/views'
set APP_URL, "https://apps.facebook.com/sinatra-tk/"


post '/' do
  @the_url = "#{APP_URL}login"
  erb :index
end

get '/' do
  @the_url = "#{APP_URL}login"
  erb :index
end

post '/login' do
  access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{APP_URL}login")
  
  @facebook_user = JSON.parse(access_token.get('/me'))
  erb :details
end