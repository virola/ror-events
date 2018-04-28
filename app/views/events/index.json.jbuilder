j_format(json) do
  json.array! @events, partial: 'events/event', as: :event
end