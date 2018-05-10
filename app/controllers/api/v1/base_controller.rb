class Api::V1::BaseController < ApplicationController

  attr_accessor :current_member
  
  def api_error(opts = {})
    render nothing: true, status: opts[:status]
  end

  def authenticate_member!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    # byebug
    member_id = params[:id]
    member_username = options.blank?? nil : options[:username]
    member = (member_id && Member.find(member_id)) || 
              (member_username && Member.find_by(:username, member_username))
    
    if member && ActiveSupport::SecurityUtils.secure_compare(member.authentication_token, token)
      self.current_member = member
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    api_error(status: 401)
  end

end