FactoryBot.define do
  factory :point_detail do
    association :principle
    point_request { create(:point_request, evaluation: principle.evaluation) }
    point { 3 }
  end
end
