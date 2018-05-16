j_format(json) do 
  # json.date @date_param
  json.date @date_param
  json.list @events, partial: 'events/event', as: :event
end 