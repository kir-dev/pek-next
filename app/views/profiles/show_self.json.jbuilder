json.user do
  json.full_name @user.full_name
  # json.compact_name @user.compact_name
  json.photo_path photo_path(@user_presenter.screen_name)
  json.profile_url profile_url(@user_presenter.screen_name)
  json.room @user.room
  json.cell_phone @user.cell_phone
  json.email @user.email
end
json.memberships(@memberships) do |membership|
  json.start_date membership.start_date
  json.end_date membership.end_date
  json.status membership.status

  group = membership.group
  json.group do
    json.id group.id
    json.url group_url(group)
    json.name group.name
  end
end