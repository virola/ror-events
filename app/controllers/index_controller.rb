class IndexController < ApplicationController
  def index
    if @_current_member
      @events = Event.where(:date => Time.now.at_beginning_of_day)
        .where('is_public = true OR (is_public = false AND member_id = ?)', @_current_member.id)
        .order(updated_at: :desc).page(params[:page]).per(5)
    else
      @events = Event.where(
        :date => Time.now.at_beginning_of_day,
        :is_public => true 
      ).order(updated_at: :desc).page(params[:page]).per(5)
    end
  end

  #GET 'index/events?date=2018-05-03'
  def events
    if params[:date].blank?
      @date_param = Time.now.at_beginning_of_day
    else
      @date_param = params[:date]
    end
    if @_current_member
      @events = Event.where(:date => @date_param)
        .where('is_public = true OR (is_public = false AND member_id = ?)', @_current_member.id)
        .order(updated_at: :desc).page(params[:page]).per(5)
    else
      @events = Event.where(
        :date => @date_param,
        :is_public => true 
      ).order(updated_at: :desc).page(params[:page]).per(5)
    end
  end
  
  # 'index/count'
  # 前后各3天，总7天的事件数目统计
  def count
    # Date.new(2007, 5, 12).change(day: 1)
    today = Date.today
    @list = []
    for i in -3..3 do
      date = today + i
      date_param = date.strftime('%Y-%m-%d')

      if @_current_member
        count = Event.where(:date => date_param)
          .where('is_public = true OR (is_public = false AND member_id = ?)', @_current_member.id)
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
