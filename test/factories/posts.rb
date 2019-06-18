FactoryBot.define do
  factory :post do

    trait :leader do
      post_type_id { Membership::LEADER_POST_ID }
    end
  end
end
