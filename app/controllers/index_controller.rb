class IndexController < ApplicationController
  def index
    # @debug_info = Time.zone
    # @events = Event.where(where(:date => date.beginning_of_day.utc..date.end_of_day.utc))
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
  
end
