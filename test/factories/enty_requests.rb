FactoryBot.define do
  factory :entry_request do
    association :evaluation
    association :user

    after(:build) do |er|
      create(:membership, user: er.user, group: er.evaluation.group)
    end

    entry_type { EntryRequest::DEFAULT_TYPE }
    justification { "Kifejezettem aktív volt a félévben." }
  end
end
