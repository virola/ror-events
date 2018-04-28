j_format(json) do
  json.array! @members, partial: 'members/member', as: :member
end 
