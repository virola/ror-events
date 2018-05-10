class Api::V1::SessionsController < Api::V1::BaseController

  def create
    @member = Member.find_by(username: create_params[:username]).authenticate(create_params[:password])
    if @member
      self.current_member = @member
    else
      api_error(status: 401)
    end
  end

  private

  def create_params
    params.require(:member).permit(:username, :open_id, :password)
  end
end
