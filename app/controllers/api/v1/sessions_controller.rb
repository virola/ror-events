class Api::V1::SessionsController < Api::V1::BaseController

  def create
    @member = Member.find_by(username: create_params[:username]).authenticate(create_params[:password])
    if @member
      self.current_member = @member
    else
      api_error(status: 401)
    end
  end

  def wx_login
    @default_password = '123456789@0'
    respond_to do |format|
      if wx_params[:session_key]
        session[:session_key] = wx_params[:session_key]
        @member_params = {
          :nickname => wx_params[:nickname],
          :open_id => wx_params[:open_id] || wx_params[:session_key],
          :union_id => wx_params[:union_id] || wx_params[:session_key],
          :username => 'wx_' + wx_params[:nickname] + wx_params[:session_key][0..5],
          :password => @default_password
        }
        # 先去检索用户是否已存在
        @member = Member.find_by(open_id: member_params[:open_id])
        if @member 
          format.json { render :create, status: :ok }
        else
          # !!!创建用户!!!
          @member = Member.new(@member_params)
          if @member.save 
            format.json { render :create, status: :created }
          else
            format.json { render json: { message: @member.errors }}
          end
          # create end
        end

      else
        format.json { render json: { message: '参数错误' }}
      end
    end
  end
  

  private

  def create_params
    params.require(:session).permit(:username, :open_id, :password)
  end
  # 微信小程序API准入参数
  def wx_params
    params.require(:session).permit(:open_id, :session_key, :union_id, :nickname)
  end
  
  def member_params
    params.require(:session).permit(:username, :open_id, :password)
  end
end
