json.principles @principle_groups

json.users @users.each { ||  } do |user|
  json.id user.id
  json.name user.full_name
  details = ['RESPONSIBILITY', 'WORK'].map do |principle_group|
    group_values = @principle_groups[principle_group].map do |principle|
      point_detail = user.single_detail(principle)
      { principleId: principle.id,
        point: point_detail&.point || 0 }
    end
    { "#{principle_group}": group_values }
  end
  json.pointDetails details.reduce({}, :merge)
end
