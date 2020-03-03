# frozen_string_literal: true

FactoryBot.define do
  factory :post_type do
    group { build(:group) }
    sequence(:name) { |n| "Post type #{n}" }
    sequence(:id, 150)
  end

  factory :post_type_leader, parent: :post_type do
    id { Membership::LEADER_POST_ID }
    name { 'Korvezeto' }
  end

  factory :post_type_newbie, parent: :post_type do
    id { Membership::DEFAULT_POST_ID }
    name { 'Feldolgozas alatt' }
  end

  factory :post_type_pek_admin, parent: :post_type do
    id { Membership::PEK_ADMIN_ID }
    name { 'PeK admin' }
  end

  factory :post_type_new_member, parent: :post_type do
    id { Membership::NEW_MEMBER_ID }
    name { 'Ujonc' }
  end
end
