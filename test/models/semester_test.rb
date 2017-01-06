require 'test_helper'

class SemesterTest < ActionController::TestCase

  test "converting from and to string" do
    assert_equal "201620171", Semester.new("201620171").to_s
  end

  test "getting the previous semester without year switch" do
    assert_equal "201620171", Semester.new("201620172").previous.to_s
  end

  test "getting the previous semester with year switch" do
    assert_equal "201520162", Semester.new("201620171").previous.to_s
  end

  test "stepping to next year" do
    assert_equal "201720181", Semester.new("201620171").next.next.to_s
  end

  test "previous semester from database" do
    assert_equal "200720082", SystemAttribute.semester.previous.to_s
  end

end
