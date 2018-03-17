# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PostType.create([
  { id: 1, name: 'gazdaságis' },
  { id: 3, name: 'körvezető' },
  { id: 4, name: 'volt körvezető' },
  { id: 6, name: 'feldolgozás alatt' },
  { id: 66, name: 'PéK admin' }
  ])

Group.create([
  { id: 369, name: 'SVIE', type: 'bizottság' },
  { id: 1, name: 'Kollégiumi bizottság', type: 'csoport' },
  { id: 146, name: 'Reszortvezetők Tanácsa', type: 'csoport', parent: 369 },
  { id: 16, name: 'Simonyi Károly Szakkollégium', type: 'reszort', parent: 146 },
  { id: 106, name: 'KIR fejlesztők és üzemeltetők', type: 'szakmai kör', parent: 16,
    description: 'A Villanykari Információs Rendszer fejlesztésével és üzemeltetésével foglalkozó kör.',
    webpage: 'http://kir-dev.sch.bme.hu', maillist: 'kir-dev@sch.bme.hu', founded: 2001, issvie: true,
    svie_delegate_nr: 1, users_can_apply: true },
  ])

                    User.create({ firstname: 'Júzer', lastname: 'Mezei', screen_name: 'mezei123' })

leader_user       = User.create({ firstname: 'Bálint Martin', lastname: 'Király', screen_name: 'kiraly96'})
leader_membership = Membership.create({ group_id: 106, user_id: leader_user.id })
                    Post.create({ membership_id: leader_membership.id, post_type_id: Membership::LEADER_POST_ID })
                    Post.create({ membership_id: leader_membership.id, post_type_id: Membership::PEK_ADMIN_ID })

rvt_member       =  User.create({ firstname: 'Elnök', lastname: 'Simonyi', screen_name: 'elnokiugy' })
                    Membership.create({ group_id: 146, user_id: rvt_member.id })

kb_user           = User.create({ firstname: 'Srác', lastname: 'KBs', screen_name: 'kbs123' })
                    Membership.create({ group_id: 1, user_id: kb_user.id })
