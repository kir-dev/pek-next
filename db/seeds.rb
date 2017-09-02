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
  { id: 6, name: 'feldolgozás alatt' }
  ])

Group.create([
  { id: 369, name: 'SVIE', type: 'bizottság' },
  { id: 146, name: 'Reszortvezetők Tanácsa', type: 'csoport', parent: 369 },
  { id: 16, name: 'Simonyi Károly Szakkollégium', type: 'reszort', parent: 146 },
  { id: 106, name: 'KIR fejlesztők és üzemeltetők', type: 'szakmai kör', parent: 16,
    description: 'A Villanykari Információs Rendszer fejlesztésével és üzemeltetésével foglalkozó kör.',
    webpage: 'http://kir-dev.sch.bme.hu', maillist: 'kir-dev@sch.bme.hu', founded: 2001, issvie: true,
    svie_delegate_nr: 1, users_can_apply: true },
  ])
