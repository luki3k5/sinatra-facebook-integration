require 'sinatra'
require 'net/https'
require 'uri'
require 'oauth2'
require 'json'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'canvas'

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
  # if we do not have the code then we render app dialog
  if params[:code].nil?
    puts "I AM HERE1 : and settings are: #{settings.inspect} GOING FWD"    
    @the_url = "http://www.facebook.com/dialog/oauth?client_id=#{settings.app_id}&redirect_uri=#{settings.app_url}"
    erb :index
  else
    oauth_client = OAuth2::Client.new(settings.app_id, settings.app_secret, :site => 'https://graph.facebook.com')    
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{settings.app_url}")    
    @facebook_user = JSON.parse(access_token.get('/me'))
    erb :details
  end    
end

