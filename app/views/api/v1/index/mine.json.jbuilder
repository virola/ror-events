j_format(json) do 
  json.date @date_param
  json.list @events, partial: 'api/v1/events/event', as: :event
end 