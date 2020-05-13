FactoryBot.define do
  factory :basic_group, class: 'Group' do
    name { 'Babhámozó' }
    type { :group }
    sequence(:id, 400)

    trait :with_additional_info do
      description { 'vietnámiak' }
      webpage { 'http://babhamozo.sch.bme.hu' }
      maillist { 'babhamozo@sch.bme.hu' }
      founded { 1998 }
    end
  end

  factory :group, parent: :basic_group do
    after(:create) do |group|
      group.memberships << create(:membership, :leader, group: group)
    end
  end

  factory :group_svie, parent: :basic_group do
    id { Group::SVIE_ID }
    name { 'SVIE' }
  end

  factory :group_rvt, parent: :basic_group do
    id { Group::RVT_ID }
    name { 'RVT' }
  end

  factory :group_kir_dev, parent: :basic_group do
    id { Group::KIRDEV_ID }
    name { 'Kir-Dev' }
  end

  factory :group_kb, parent: :basic_group do
    id { Group::KB_ID }
    name { 'KB' }
  end
end
