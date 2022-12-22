FactoryBot.define do
  factory :membership do
    association :user
    association :group
    start_date { '2010-02-02' }

    trait :leader do
      after(:create) do |membership|
        membership.posts << build(:post, :leader)
      end
    end

    trait :leader_assistant do
      after(:create) do |membership|
        membership.posts << build(:post, :leader_assistant)
      end
    end

    trait :newbie do
      after(:create) do |membership|
        membership.posts << build(:post, :newbie)
      end
    end

    trait :with_point_request do
      after(:create) do |membership|
        evaluation = create(:evaluation, group: membership.group)

        PointRequest.create!(evaluation: evaluation, user: membership.user)
      end
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

    trait :for_kir_dev_group do
      group { Group.find_by(name: 'Kir-Dev') }
    end

    trait :for_rvt_group do
      group { Group.find(Group::RVT_ID) }
    end
  end
end
