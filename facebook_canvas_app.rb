require 'sinatra'
require 'net/https'
require 'oauth2'
require 'json'

configure do
  set :views, File.dirname(__FILE__) + '/views'
  
  # reading in the config with the details about fb application
  yml = YAML::load(File.open(File.dirname(__FILE__) + "/facebook_app_config.yml"))
  
  set :app_id,     yml["app_id"]
  set :app_name,   yml["app_name"]
  set :app_secret, yml["app_secret"]

  set :app_url,   "https://apps.facebook.com/#{settings.app_name}/"
  set :oauth_url, "https://www.facebook.com/dialog/oauth/"
end

post '/' do
  # if we do not have the code then we render app dialog with client side redirect...
  if params[:code].nil?
    @the_url = "http://www.facebook.com/dialog/oauth?client_id=#{settings.app_id}&redirect_uri=#{settings.app_url}"
    erb :index  
  else # we obtain the details for the current logged in user from FB 
    oauth_client = OAuth2::Client.new(settings.app_id, settings.app_secret, :site => 'https://graph.facebook.com')    
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{settings.app_url}")    
    @facebook_user = JSON.parse(access_token.get('/me'))
    erb :details
  end    
end

