module EventsHelper
  def date_format(date)
    # byebug
    if !date.blank?
      time = Time.now
      if time.year != date.year
        date.strftime('%y.%m.%d') 
      else
        date.strftime('%m.%d')
      end
    else
      ''
    end
  end
end
