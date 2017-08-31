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

  test "membership for group" do
    assert true #TODO
  end

  test "primary membership" do
    membership = users(:user_with_primary_membership).primary_membership
    assert_equal grp_membership(:user_with_primary_membership), membership
  end

  test "when primary membership id not definied" do
    membership = users(:sanyi).primary_membership
    assert_nil membership
  end
end
