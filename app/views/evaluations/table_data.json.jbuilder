json.principles @ordered_principles do |principle|
  json.id principle.id
  json.name principle.name
  json.type principle.type
end
json.users @users.map do |user|
  json.id user.id
  json.name user.full_name
  json.pointsDetails @ordered_principles.each do |principle|
    point_detail = user.single_detail(principle)
    json.principleId principle.id
    json.point point_detail&.point || 0
  end
end
