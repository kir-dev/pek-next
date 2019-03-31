FactoryBot.define do
  factory :principle do
    max_per_member { 20 }
    association :evaluation
    type { Principle::WORK }
    name { 'ha muszáj' }
  end
end
