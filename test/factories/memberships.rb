FactoryBot.define do
  factory :membership do
    association :user
    association :group
    start_date { '2010-02-02' }

    trait :leader do
      posts { create_list(:post, 1, :leader) }
    end

    trait :newbie do
      posts { create_list(:post, 1, :newbie) }
    end

    trait :inactive do
      end_date { Time.now }
    end

    trait :archived do
      archived { Time.now }
    end

    trait :for_svie_group do
      association :group, issvie: true
    end
  end
end
