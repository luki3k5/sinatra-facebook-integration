require 'sinatra'
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

# helpers do
#   def get_current_user(app_secret)
#     request = JSON.parse(params[:user_session])["signed_request"] unless params[:user_session].nil? || params[:user_session]["signed_request"].nil?
#     request = params["signed_request"] unless !request.nil? # this is when FB pings us for deauthorize
#   
#     data = FBGraph::Canvas.parse_signed_request(app_secret, request) unless request.nil?
#     @access_token = data["oauth_token"]  unless data.nil?
#     # ... TODO here - check in DB if we have the user stored 
#   end
# end

post '/' do
  
  # if we do not have the code then we render app dialog
  if params[:code].nil?
    puts "I AM HERE1 : and settings are: #{settings.inspect} GOING FWD"    
    @the_url = "http://www.facebook.com/dialog/oauth?client_id=#{settings.app_id}&redirect_uri=#{settings.app_url}"
    erb :index
  else
    puts "I AM HERE2 : and settings are: #{settings.app_id} #{settings.app_secret} #{settings.app_url} GOING FWD"
    oauth_client = OAuth2::Client.new(settings.app_id, settings.app_secret, :site => 'https://graph.facebook.com')
    puts "I AM HERE3: #{oauth_client.inspect}"
    puts "I AM HERE4: #{oauth_client.web_server.inspect}"    
    
    access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{settings.app_url}")
    @facebook_user = JSON.parse(access_token.get('/me'))
    erb :details
  end  
  
  # if get_current_user(settings.app_secret)
  #   @the_url = "#{settings.app_url}login"
  # else
  #   @the_url = "#{settings.oauth_url}?client_id=#{settings.app_id}&redirect_uri=#{settings.app_url}login&scope=email" # HERE IS WHAT WE REQUEST (EMAIL ONLY)
  # end
  # erb :index
end

# Second step is to perform oauth authentycation and obtain data
# post '/login' do
#   oauth_client = OAuth2::Client.new(settings.app_id, settings.app_secret, :site => 'https://graph.facebook.com')
#   unless params[:code].nil?
#     access_token = oauth_client.web_server.get_access_token(params[:code], :redirect_uri => "#{settings.app_url}login")
#     @facebook_user = JSON.parse(access_token.get('/me'))
#   end
#   erb :details
# end