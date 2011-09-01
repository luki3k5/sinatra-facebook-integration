require 'oauth2'
require 'json'
require 'canvas'

module FacebookHelpers

  # filter for authorization   
  def get_current_user(app_secret)
    request = JSON.parse(params[:user_session])["signed_request"] unless params[:user_session].nil? || params[:user_session]["signed_request"].nil?
    request = params["signed_request"] unless !request.nil? # this is when FB pings us for deauthorize
  
    data = FBGraph::Canvas.parse_signed_request(app_secret, request) unless request.nil?
    @access_token = data["oauth_token"]  unless data.nil?
  
    # if !data.nil?
    #   user = FacebookUser.find_by_facebook_id(data["user_id"])
    #   return user
    # else
    #   # FIXME REMOVE TODO # THIS IS DEV ONLY
    #   begin 
    #     return FacebookUser.find_by_facebook_id(JSON.parse(params[:user_session])["user_id"])             
    #   rescue 
    #     return nil
    #   end
    # end
  end
  
end