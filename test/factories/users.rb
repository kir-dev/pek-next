FactoryBot.define do
  factory :user do
    firstname { 'Sándor' }
    lastname  { 'Hentes' }

    sequence(:screen_name) { |n| "screen_name_sanyi_#{n}" }

    trait :with_primary_membership do
      svie_member_type { 'RENDESTAG' }
      after(:build) do |user|
        user.svie_primary_membership = create(:membership, user: user).id
      end
    end

    trait :who_delegated do
      delegated { true }

      with_primary_membership
    end
  end
end
