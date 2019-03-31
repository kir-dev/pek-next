FactoryBot.define do
  factory :point_request do
    association :user
    association :evaluation, factory: :babhamozo_2018_evaluation

    after(:build) do |pr|
      create(:membership, user: pr.user, group: pr.evaluation.group)
    end
  end
end
