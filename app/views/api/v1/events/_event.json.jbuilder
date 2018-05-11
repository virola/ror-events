json.extract! event, :id, :name, :description, :is_public, :date, :member_id
# format date
json.date_format date_format(event.date)

# 设定显示字段
json.member do
  json.username event.member.username
  json.bio event.member.bio
  json.nickname event.member.nickname
end
# 管理员显示
if @current_member && @current_member.role == 'admin'
  json.(event, :created_at, :updated_at)
end
json.url event_url(event, format: :json)
