j_format(json) do
  json.partial! "api/v1/members/member", member: @member
  if @current_member && @current_member.role == 'admin'
    json.(@member, :open_id, :union_id, :created_at, :updated_at)
  end
end
