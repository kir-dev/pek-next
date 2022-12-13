# frozen_string_literal: true

FactoryBot.define do
  factory :sub_group_membership do
    admin { false }
    association :sub_group

    before(:create) do |sub_group_membership|
      membership = create(:membership, group: sub_group_membership.sub_group.group)
      sub_group_membership.membership = membership
    end
  end
end