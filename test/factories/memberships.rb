FactoryBot.define do
  factory :membership do
    association :user
    association :group
    membership_start { '2010-02-02' }
  end
end
