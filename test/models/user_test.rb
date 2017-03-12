require 'test_helper'

class UserTest < ActionController::TestCase
  test "test cellphone format invalid" do
    user = users(:sanyi)
    user.cell_phone = "asdf"

    refute user.valid?
    refute_empty user.errors[:cell_phone]
  end

  test "test cellphone format valid" do
    user = users(:sanyi)
    user.cell_phone = "+36201234567"

    assert user.valid?
    assert_empty user.errors[:cell_phone]
  end

  test "test cellphone can be empty" do
    user = users(:sanyi)
    user.cell_phone = ""

    assert user.valid?
    assert_empty user.errors[:cell_phone]
  end
end
