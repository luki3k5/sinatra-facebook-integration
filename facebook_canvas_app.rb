require 'sinatra'
require 'oauth2'
require 'json'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'facebook_helpers'

set :views, File.dirname(__FILE__) + '/views'

configure do
  # reading in the config with the details about fb application
  yml = YAML::load(File.open(File.dirname(__FILE__) + "/facebook_app_config.yml"))
  
  set :app_id,     yml["app_id"]
  set :app_name,   yml["app_name"]
  set :app_secret, yml["app_secret"]

  set :app_url,   "https://apps.facebook.com/#{settings.app_name}/"
  set :oauth_url, "https://www.facebook.com/dialog/oauth/"
end

# First step is to display page with redirect
post '/' do
  if get_current_user(settings.app_secret)
    @the_url = "#{settings.app_url}login"
  else
    @the_url = "#{settings.oauth_url}?client_id=#{settings.app_id}&redirect_uri=#{settings.app_url}&scope=email" # HERE IS WHAT WE REQUEST (EMAIL ONLY)
  end
  erb :index
end

# Second step is to perform oauth authentycation and obtain data
post '/login' do
  oauth_client = OAuth2::Client.new(settings.app_id, settings.app_secret, :site => 'https://graph.facebook.com')
  access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{settings.app_url}login")
  
  @facebook_user = JSON.parse(access_token.get('/me'))
  erb :details
end

