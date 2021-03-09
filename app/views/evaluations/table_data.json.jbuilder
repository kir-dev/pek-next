json.array! @users.each_with_index.to_a do |user, index|
  # json.id index
  json.userName user.full_name
  @ordered_principles.each do |principle|
    point_detail = user.single_detail(principle)
    json.set! "principle-#{principle.id}", point_detail&.point
  end
end
