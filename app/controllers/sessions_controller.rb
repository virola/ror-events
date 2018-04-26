class SessionsController < ApplicationController
  def new
  end
 
  def create
    if member_params[:username]
      @member = Member.find_by(username: member_params[:username]).try(:authenticate, member_params[:password])
    else
      @member = Member.find_by(open_id: member_params[:open_id]).try(:authenticate, member_params[:password])
    end
    respond_to do |format|
      if @member
        session[:current_member_id] = @member.id
        session[:current_username] = @member.username
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
    session[:current_username] = nil
    flash[:notice] = '退出成功'
    redirect_to root_path
  end
 
  private
  def member_params
    params.require(:session).permit(:username, :open_id, :password)
  end
end
