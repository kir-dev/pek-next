require 'test_helper'

class PointDetailTest < ActionController::TestCase
  test 'save point less then zero will be zero' do
    point_detail = point_details(:point_detail_1)
    point = -5000

    point_detail.update(point: point)
    assert_equal 0, point_detail.point
  end

  test 'save point greater then max will be max' do
    point_detail = point_details(:point_detail_1)
    max_point = point_detail.principle.max_per_member
    point = max_point + 100

    point_detail.update(point: point)
    assert_equal max_point, point_detail.point
  end
end
