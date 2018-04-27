json.extract! event, :id, :name, :description, :is_public, :date
json.url event_url(event, format: :json)
# 设定显示字段
json.member do
  json.username event.member.username
  json.bio event.member.bio
end
# 管理员显示
if @_current_member.role == 'admin'
  json.(event, :member_id, :created_at, :updated_at)
end