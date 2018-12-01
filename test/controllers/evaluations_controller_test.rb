require 'test_helper'

class EvaluationsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:evaluation_giver)
  end

  test 'forbidden page for non group leaders' do
    login_as_user(:sanyi)
    get :current, group_id: groups(:group_with_no_evaluation).id

    assert_response :forbidden
  end

  test 'create new evaluation if missing' do
    get :current, group_id: groups(:group_with_no_evaluation).id

    new_evaluation = Evaluation.find_by(
      group_id: groups(:group_with_no_evaluation).id, semester: SystemAttribute.semester.to_s
    )

    assert_not_nil new_evaluation
    assert_redirected_to group_evaluation_path(groups(:group_with_no_evaluation), new_evaluation)
  end
end
