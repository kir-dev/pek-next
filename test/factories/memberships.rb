FactoryBot.define do
  factory :membership do
    association :user
    association :group
    membership_start { '2010-02-02' }

    trait :leader do
      posts { create_list(:post, 1, :leader) }
    end
  end
end
