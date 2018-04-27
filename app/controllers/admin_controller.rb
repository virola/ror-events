class AdminController < ApplicationController
  USERS = { 'virola' => 'rubyadmin' }
  before_action :authenticate
  
  def index
    
  end

 
  private
 
  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end
  
end
