# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PostType.create([
  { id: PostType::FINANCIAL_OFFICER_POST_ID, name: 'gazdaságis' },
  { id: PostType::LEADER_POST_ID, name: 'körvezető' },
  { id: PostType::PAST_LEADER_ID, name: 'volt körvezető' },
  { id: PostType::DEFAULT_POST_ID, name: 'feldolgozás alatt' },
  { id: PostType::PEK_ADMIN_ID, name: 'PéK admin' },
  { id: PostType::NEW_MEMBER_ID, name: 'újonc' }
  ])

# These are not necessary to run the application, but required for full operation

Group.create([
  { id: Group::SVIE_ID, name: 'SVIE', type: :team },
  { id: Group::KB_ID, name: 'Kollégiumi bizottság', type: :group },
  { id: Group::RVT_ID, name: 'Reszortvezetők Tanácsa', type: :group, parent_id: Group::SVIE_ID },
  { id: Group::SIMONYI_ID, name: 'Simonyi Károly Szakkollégium', type: :team, parent_id: Group::RVT_ID },
  { id: Group::KIRDEV_ID, name: 'KIR fejlesztők és üzemeltetők', type: :group, parent_id: Group::SIMONYI_ID,
    description: 'A Villanykari Információs Rendszer fejlesztésével és üzemeltetésével foglalkozó kör.',
    webpage: 'http://kir-dev.sch.bme.hu', maillist: 'kir-dev@sch.bme.hu', founded: 2001, issvie: true,
    delegate_count: 1, users_can_apply: true }
  ])

User.create({ firstname: 'Júzer', lastname: 'Mezei', screen_name: 'mezei123' })


# Create leaders for the groups
[
  { firstname: 'Elnok', lastname: 'Rvt', screen_name: 'rvt_elnok', group_id: Group::RVT_ID },
  { firstname: 'Elnok', lastname: 'Svie', screen_name: 'svie_elnok', group_id: Group::SVIE_ID },
  { firstname: 'Körvez', lastname: 'KirDev', screen_name: 'kir_dev_korvez', group_id: Group::KIRDEV_ID },
  { firstname: 'Elnök', lastname: 'Simonyi', screen_name: 'elnokiugy', group_id: Group::SIMONYI_ID}
].each do |item|
  leader_user = User.create(firstname: item[:firstname], lastname: item[:lastname], screen_name: item[:screen_name])
  leader_membership = Membership.create(group_id: item[:group_id], user_id: leader_user.id)

  Post.create(membership_id: leader_membership.id, post_type_id: PostType::LEADER_POST_ID)

  case item[:group_id]
  when Group::SVIE_ID
    kb_membership = Membership.create(group_id: Group::KB_ID, user_id: leader_user.id)
    Post.create(membership_id: kb_membership.id, post_type_id: PostType::LEADER_POST_ID)
  when Group::KIRDEV_ID
    Post.create(membership_id: leader_membership.id, post_type_id: PostType::PEK_ADMIN_ID)
  when Group::SIMONYI_ID
    Membership.create(group_id: Group::RVT_ID, user_id: leader_user.id)
  end
end

kb_user = User.create(firstname: 'Masik Srác', lastname: 'KBs', screen_name: 'kbs123')
Membership.create(group_id: Group::KB_ID, user_id: kb_user.id)

# Maybe it is better to use sequence for id
SystemAttribute.create(id: 1, name: 'szemeszter', value: '201720182')
SystemAttribute.create(id: 2, name: 'ertekeles_idoszak', value: 'NINCSERTEKELES')
