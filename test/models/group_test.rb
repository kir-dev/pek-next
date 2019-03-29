require 'test_helper'

class GroupTest < ActionController::TestCase
  test 'group is active when newly founded' do
    group = groups(:babhamozo)
    time = Time.new(group.founded)

    Timecop.travel(time) do
      assert_not group.inactive?
    end
  end

  test 'group without evaluation is inactive two years after founded' do
    group = groups(:babhamozo)
    time = Time.new(group.founded + 2)

    Timecop.travel(time) do
      assert group.inactive?
    end
  end

  test 'group with evaluation in last semester is active' do
    group = groups(:babhamozo)
    evaluation = evaluations(:babhamozo_2018)

    SystemAttribute.stubs(:semester).returns(Semester.new(evaluation.semester).next!)

    assert_not group.inactive?
  end
end
