FactoryBot.define do
  factory :user do
    firstname { 'Sándor' }
    lastname  { 'Hentes' }

    sequence(:screen_name) { |n| "screen_name_sanyi_#{n}" }

    trait :with_primary_membership do
      svie_member_type { 'RENDESTAG' }
      svie_primary_membership { 4 }
    end
  end
end
