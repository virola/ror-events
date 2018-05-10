if @member
  json.member do
    json.(@member, :id, :username, :nickname)
  end
end