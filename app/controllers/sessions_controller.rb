class SessionsController < ApplicationController
  def new
  end

  # 给微信小程序使用的通过CODE和加密数据登录或创建用户的API
  # 仅给微信小程序使用，可能需要限制来源？？
  def login_open_id
    @default_password = '123456789@0'
    respond_to do |format|
      if wx_params[:session_key]
        session[:session_key] = wx_params[:session_key]
        @member_params = {
          :open_id => wx_params[:open_id] || wx_params[:session_key],
          :username => 'wxuser' + wx_params[:session_key][0..5],
          :password => @default_password
        }
        # 先去检索用户是否已存在
        @member = Member.find_by(open_id: member_params[:open_id])
        if @member.id 
          format.json { render :login_open_id, status: :ok }
        else
          # !!!创建用户!!!
          @member = Member.new(@member_params)
          if @member.save 
            format.json { render :login_open_id, status: :created }
            # 
          else
            format.json { render json: @member.errors }
          end
          # create end
        end
        # 然后默认登录
        session[:current_member_id] = @member.id
        session[:current_username] = @member.username

      else
        format.json { render json: { message: '参数错误' }}
      end
    end
  end

  def get_session_key
    respond_to do |format|
      if session[:session_key]
        format.json { render json: { status: 'ok', data: { session_key: session[:session_key]}}, status: :ok}
      else
        format.json { render json: { status: 'error', message: '无效请求' }}
      end
      
    end
    
  end
  
  
 
  # 登录
  # POST /sessions/create
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
        format.json { render json: { message: '用户名或者密码不正确', status: 'error'}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:current_member_id] = nil
    session[:current_username] = nil
    session[:session_key] = nil
    @message = '退出成功'
    respond_to do |format|
      format.html { redirect_to root_path, notice: @message }
      format.json { render json: { message: @message, status: :ok }, status: :ok }
    end
  end
 
  private
  # 微信小程序API准入参数
  def wx_params
    params.require(:session).permit(:code, :session_key)
  end
  
  def member_params
    params.require(:session).permit(:username, :open_id, :password)
  end
end
