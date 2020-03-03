FactoryBot.define do
  factory :evaluation do
    association :group

    date { '201720181' }
    justification { 'Lyo lesz' }

    factory :babhamozo_2018_evaluation do
      entry_request_status { Evaluation::ACCEPTED }
      point_request_status { Evaluation::ACCEPTED }
      timestamp { '2018-01-02' }
      last_evaulation { '2018-01-20' }
      last_modification { '2018-01-03' }
      reviewer_user_id { create(:user).id }
      creator_user_id { create(:user).id }
      principle { 'Aki dolgozik az kap pontot' }
    end

    trait :accepted do
      point_request_status { Evaluation::ACCEPTED }
    end
  end
end
