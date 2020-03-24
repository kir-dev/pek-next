FactoryBot.define do
  factory :post do

    trait :leader do
      post_type_id { PostType::LEADER_POST_ID }
    end

    trait :newbie do
      post_type_id { PostType::DEFAULT_POST_ID }
    end
  end
end
