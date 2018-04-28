j_format(json) do 
  json.partial! "events/event", event: @event
end
