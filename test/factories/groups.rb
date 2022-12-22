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

    after(:create) do |group|
      user = create(:user)
      membership = Membership.create!(user: user, group: group)
      CreatePost.call(group, membership, PostType::EVALUATION_HELPER_ID)
    end

    after(:create) do |group|
      user = create(:user)
      membership = Membership.create!(user: user, group: group)
      CreatePost.call(group, membership, PostType::LEADER_ASSISTANT_ID)
    end
  end

  factory :group_with_parent, parent: :group do
    parent { create(:group) }

    after(:create) do |group|
      group.parent.update(parent_id: Group::RVT_ID)
    end

    after(:create) do |group|
      sibling_group = create(:group)
      sibling_group.update(parent: group.parent)
    end
  end

  factory :group_svie, parent: :basic_group do
    id { Group::SVIE_ID }
    name { 'SVIE' }
  end

  factory :group_rvt, parent: :group do
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

  factory :group_sssl, parent: :basic_group do
    id { Group::SSSL_ID }
    name { 'Szent Schönherz Senior Lovagrend' }
  end
end
