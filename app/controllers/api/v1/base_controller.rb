class Api::V1::BaseController < ApplicationController

  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :destroy_session

  # disable the CSRF token
  skip_before_action :verify_authenticity_token

  def destroy_session
    request.session_options[:skip] = true
  end
  
  attr_accessor :current_member
  
  def api_error(opts = {})
    opts[:message] = opts[:message] ? opts[:message] : 'API调用错误'
    # byebug
    respond_to do |format|
      format.json { render json: { message: opts[:message], status: opts[:status] }, status: opts[:status] }
    end
  end

  def auth_token_member!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    # byebug
    member_username = options.blank?? nil : options['username']
    if member_username
      @member = Member.find_by_username(member_username)
      if @member && ActiveSupport::SecurityUtils.secure_compare(@member.authentication_token, token)
        self.current_member = @member
      end
    end
  end

  def authenticate_member!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    # byebug
    member_username = options.blank?? nil : options['username']
    if member_username
      @member = Member.find_by_username(member_username)
      if @member && ActiveSupport::SecurityUtils.secure_compare(@member.authentication_token, token)
        self.current_member = @member
      else
        return unauthenticated!
      end
    else
      return unauthenticated!
    end
    
  end

  def unauthenticated!
    api_error(status: 401, message: '没有操作权限')
  end

end