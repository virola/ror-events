if @member
  j_format(json) do
    json.partial! "api/v1/members/member", member: @member
    json.token @member.authentication_token
  end
end