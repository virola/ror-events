if @member
  json.session do
    json.(@member, :id, :username, :nickname, :role)
    json.token @member.authentication_token
  end
end