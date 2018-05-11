j_format(json) do 
  json.partial! "api/v1/events/event", event: @event
end
