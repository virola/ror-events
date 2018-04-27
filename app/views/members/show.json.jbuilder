json.partial! "members/member", member: @member

json.(@member, :open_id, :union_id, :created_at, :updated_at)