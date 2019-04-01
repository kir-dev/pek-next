require 'test_helper'

class EvaluationTest < ActiveSupport::TestCase
  test 'creating a new evaluation sets default values' do
    evaluation = Evaluation.new
    evaluation.group = create(:group)
    evaluation.semester = '201720182'

    Timecop.freeze do
      assert evaluation.save

      assert evaluation.point_request_status, Evaluation::NON_EXISTENT
      assert evaluation.entry_request_status, Evaluation::NON_EXISTENT
      assert evaluation.justification, ''
      assert evaluation.timestamp, Time.now
      assert evaluation.last_modification, Time.now
    end
  end
end
