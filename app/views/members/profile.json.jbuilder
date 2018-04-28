j_format(json) do
  json.partial! "members/member", member: @member
end 
