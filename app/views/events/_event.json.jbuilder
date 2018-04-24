json.extract! event, :id, :name, :description, :is_public, :date, :member_id, :created_at, :updated_at
json.url event_url(event, format: :json)
