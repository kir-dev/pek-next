json.array! @users do |user|
  json.userName user.full_name
  @ordered_principles.each do |principle|
    point_detail = user.single_detail(principle)
    json.set! "principle-#{principle.id}", point_detail&.point
  end
end
