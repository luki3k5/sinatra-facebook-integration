require 'sinatra'
require 'oauth2'
require 'json'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'facebook_helpers'

set :views, File.dirname(__FILE__) + '/views'

# reading in the config with the details about fb application
yml = YAML::load(File.open(File.dirname(__FILE__) + "/facebook_app_config.yml"))

set APP_ID,     yml["app_id"]
set APP_NAME,   yml["app_name"]
set APP_SECRET, yml["app_secret"]

set APP_URL,   "https://apps.facebook.com/#{APP_NAME}/"
set OAUTH_URL, "https://www.facebook.com/dialog/oauth/"

# First step is to display page with redirect
post '/' do
  if get_current_user
    @the_url = "#{APP_URL}login"
  else
    @the_url = "#{OAUTH_URL}?client_id=#{@APP_ID}&redirect_uri=#{APP_URL}&scope=email" # HERE IS WHAT WE REQUEST (EMAIL ONLY)
  end
  erb :index
end

# Second step is to perform oauth authentycation and obtain data
post '/login' do
  oauth_client = OAuth2::Client.new(APP_ID, APP_SECRET, :site => 'https://graph.facebook.com')
  access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{APP_URL}login")
  
  @facebook_user = JSON.parse(access_token.get('/me'))
  erb :details
end

