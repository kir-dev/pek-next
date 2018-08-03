require 'test_helper'

class PointHistoryCalculationTest < ActionController::TestCase
  test 'calculate point history at changing to offseason' do
    point_history_count = PointHistory.count

    evaluation = evaluations(:babhamozo_2018)
    SystemAttribute.update_semester(evaluation.date_as_semester)
    SystemAttribute.update_season(SystemAttribute::OFFSEASON)

    assert_equal point_history_count + 1, PointHistory.count
  end

  test 'delete previous point history at recalculation' do
    point_history_count = PointHistory.count

    evaluation = evaluations(:babhamozo_2018)
    SystemAttribute.update_semester(evaluation.date_as_semester)
    SystemAttribute.update_season(SystemAttribute::OFFSEASON)
    SystemAttribute.update_season(SystemAttribute::APPLICATION_SEASON)
    SystemAttribute.update_season(SystemAttribute::OFFSEASON)

    assert_equal point_history_count + 1, PointHistory.count
  end

  test 'point request will be maximized in hundred' do
    evaluation = evaluations(:babhamozo_2018)
    user = users(:babhamozo_leader)
    SystemAttribute.update_semester(evaluation.date_as_semester.next)
    SystemAttribute.update_season(SystemAttribute::OFFSEASON)
    point_history = PointHistory.find_by(user: user)

    assert point_history.point == SystemAttribute.max_point_for_semester
  end
end
