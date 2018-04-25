class ApplicationController < ActionController::Base
  # 启动了CSRF安全性功能，所有非GET的HTTP request都必须带有一个Token参数才能存取
  protect_from_forgery
  # alert
  add_flash_types :alert

  # before_action :set_timezone
  before_action :set_locale, :current_member, :detect_browser

  protected
  
  def detect_browser
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end

  def authenticate_admin
    unless @_current_member && @_current_member.id < 4
      flash[:alert] = '没有管理权限'
      redirect_to root_path
    end
  end
  # 验证登录用户
  def authenticate_member
    # todo...
    unless @_current_member && @_current_member.id?
      flash[:alert] = '请先登录'
      redirect_to new_session_path
    end
    # @current_member = current_member && current_member[:id]
  end

  private
 
  # 使用会话中 :current_member_id  键存储的 ID 查找用户
  # Rails 应用经常这样处理用户登录
  # 登录后设定这个会话值，退出后删除这个会话值
  def current_member
    @_current_member ||= session[:current_member_id] &&
      Member.find_by(id: session[:current_member_id])
    # print()
  end

  # def set_timezone
  #   if current_member && current_member.time_zone
  #     Time.zone = current_member.time_zone
  #   end
  # end

  def set_locale
    # 可以将 ["en", "zh-TW"] 设定为 VALID_LANG 放到 config/environment.rb 中
    if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end
end
