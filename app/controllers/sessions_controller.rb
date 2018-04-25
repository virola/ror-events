class SessionsController < ApplicationController
  def new
  end
 
  def create
    @member = Member.find_by(open_id: member_params[:open_id]).try(:authenticate, member_params[:password])
    respond_to do |format|
      if @member
        session[:current_member_id] = @member.id
        format.html { redirect_to root_path, notice: 'welcome!' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { redirect_to new_session_path, alert: '用户名或者密码不正确' }
        format.json { render json: '用户名或者密码不正确', status: :unprocessable_entity }
      end
      
    end
    
  end

  def destroy
    session[:current_member_id] = nil
    flash[:notice] = '退出成功'
    redirect_to root_path
  end
 
  private
  def member_params
    params.require(:session).permit(:open_id, :password)
  end
end
