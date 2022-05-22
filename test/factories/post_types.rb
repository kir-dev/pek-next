# frozen_string_literal: true

FactoryBot.define do
  factory :post_type do
    group { build(:basic_group) }
    sequence(:name) { |n| "Post type #{n}" }
    sequence(:id, 150)
  end

  factory :common_post_type, parent: :post_type do
    group { nil }
  end
  factory :post_type_financial_officer, parent: :common_post_type do
    id { PostType::FINANCIAL_OFFICER_POST_ID }
    name { 'Gazdasagis' }
  end

  factory :post_type_leader, parent: :common_post_type do
    id { PostType::LEADER_POST_ID }
    name { 'Korvezeto' }
  end

  factory :post_type_newbie, parent: :post_type do
    id { PostType::DEFAULT_POST_ID }
    name { 'Feldolgozas alatt' }
  end

  factory :post_type_pek_admin, parent: :common_post_type do
    group { Group.kirdev }
    id { PostType::PEK_ADMIN_ID }
    name { 'PeK admin' }
  end

  factory :post_type_new_member, parent: :common_post_type do
    id { PostType::NEW_MEMBER_ID }
    name { 'Ujonc' }
  end

  factory :post_type_evaluation_helper, parent: :common_post_type do
    id { PostType::EVALUATION_HELPER_ID }
    name { 'Pontozó' }
  end
end
