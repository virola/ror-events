j_format(json) do 
  json.array! @events, partial: 'api/v1/events/event', as: :event
end 