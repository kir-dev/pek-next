FactoryBot.define do
  factory :group do
    name { 'Babhámozó' }
    type { :group }
    sequence(:id, 400)

    after(:create) do |group|
      group.memberships << create(:membership, :leader, group: group)
    end

    trait :with_additional_info do
      description { 'vietnámiak' }
      webpage { 'http://babhamozo.sch.bme.hu' }
      maillist { 'babhamozo@sch.bme.hu' }
      founded { 1998 }
    end
  end

  factory :group_svie, parent: :group do
    id { Group::SVIE_ID }
    name { 'SVIE' }
  end

  factory :group_rvt, parent: :group do
    id { Group::RVT_ID }
    name { 'RVT' }
  end

  factory :group_kir_dev, parent: :group do
    id { Group::KIRDEV_ID }
    name { 'Kir-Dev' }
  end

  factory :group_kb, parent: :group do
    id { Group::KB_ID }
    name { 'KB' }
  end
end
