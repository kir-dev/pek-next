json.principles @principle_groups

json.users @users.map do |user|
  json.id user.id
  json.name user.full_name
  json.pointDetails @principle_groups.values.flatten.each do |principle|
    point_detail = user.single_detail(principle)
    json.principleId principle.id
    json.point point_detail&.point || 0
  end
end
