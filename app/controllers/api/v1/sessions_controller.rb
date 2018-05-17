class Api::V1::SessionsController < Api::V1::BaseController
  before_action :check, only: [:wx_login]

  def create
    @member = Member.find_by(username: create_params[:username]).authenticate(create_params[:password])
    if @member
      self.current_member = @member
    else
      api_error(status: 401)
    end
  end

  def wx_login
    # action之前先验证code是否正确，得到open_id, union_id等
    # 然后再登录，接受的登录参数为 :code, :nickname
    @default_password = '123456789@0'
    respond_to do |format|
      if @session && !@session[:session_key].blank?
        # session[:session_key] = wx_params[:session_key]
        @member_params = {
          # 昵称去掉前后空白符
          :nickname => wx_params[:nickname].strip,
          :open_id => @session[:open_id],
          :union_id => @session[:union_id] || @session[:session_key],
          :username => 'wx_' + wx_params[:nickname].gsub(' ','') + '_' + @session[:open_id][0..5],
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

  def check
    # 小程序ID
    appid = ENV['WX_APP_ID']
    appsecret = ENV['WX_APP_SECRET']

    code = wx_params[:code]
    if code.blank?
      return api_error(status: 402, message: '参数错误')
    else
      url = 'https://api.weixin.qq.com/sns/jscode2session' + "?appid=#{appid}&secret=#{appsecret}&js_code=#{code}&grant_type=authorization_code"

      response = HTTParty.get(url)
      # puts response.body, response.code, response.message, response.headers.inspect
      if response.code == 200
        @res = JSON.parse response.body, symbolize_names: true
        puts '----> WEIXIN API request....', @res
        if @res[:errcode] && @res[:errcode] > 0
          return api_error(status: @res[:errcode], message: @res[:errmsg])
        else
          @session = { :open_id => @res[:openid], :union_id => @res[:unionid], :session_key => @res[:session_key] }
          session[:session_key] = @session[:session_key]
        end
      else
        return api_error(status: response.code, message: response.message)
      end
    end
    
  end

  def create_params
    params.require(:session).permit(:username, :open_id, :password)
  end
  # 微信小程序API准入参数
  def wx_params
    params.permit(:code, :nickname)
  end
  
  def member_params
    params.require(:session).permit(:username, :open_id, :password)
  end
end
