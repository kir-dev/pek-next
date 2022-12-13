FactoryBot.define do
  factory :principle do
    max_per_member { 20 }
    association :evaluation
    type { Principle::WORK }
    name { 'ha muszáj' }

    factory :sub_group_principle do
      sub_group { create(:sub_group, group: evaluation.group)}
    end
  end
end
