class AdminController < ApplicationController
  
  def index
    
  end

  USERS = { 'virola' => 'rubyadmin' }
  before_action :authenticate
 
  private
 
  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end
  
end
