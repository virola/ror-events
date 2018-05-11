class Api::V1::IndexController < Api::V1::BaseController
  def pagesize
    10
  end

  before_action :auth_token_member!, only: [:events, :count]
  
  #GET 'api/v1/index/events.json?date=2018-05-03'
  def events
    if params[:date].blank?
      @date_param = Time.now.at_beginning_of_day
    else
      @date_param = params[:date]
    end
    if @current_member
      @events = Event.where(:date => @date_param)
        .where('is_public = true OR (is_public = false AND member_id = ?)', @current_member.id)
        .order(updated_at: :desc).page(params[:page]).per(pagesize)
    else
      @events = Event.where(
        :date => @date_param,
        :is_public => true 
      ).order(updated_at: :desc).page(params[:page]).per(pagesize)
    end
  end

  # 'api/v1/index/count.json'
  # 前后各3天，总7天的事件数目统计
  def count
    today = Date.today
    @list = []
    for i in -3..3 do
      date = today + i
      date_param = date.strftime('%Y-%m-%d')

      if @current_member
        count = Event.where(:date => date_param)
          .where('is_public = true OR (is_public = false AND member_id = ?)', @current_member.id)
          .count
      else
        count = Event.where(
          :date => date_param,
          :is_public => true 
        ).count
      end
      # p count
      @list.push({
        :date => date,
        :count => count
      })
    end
  end

end
