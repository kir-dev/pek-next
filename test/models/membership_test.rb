require 'test_helper'

class MembershipTest < ActionController::TestCase
  test 'delegation became false when archive' do
    user = create(:user, :who_delegated)
    membership = user.primary_membership

    assert membership.user.delegated
    membership.archive!

    assert_not membership.reload.user.delegated
  end

  test 'delegation became false when inactivate' do
    user = create(:user, :who_delegated)
    membership = user.primary_membership

    assert membership.user.delegated
    membership.inactivate!

    assert_not membership.reload.user.delegated
  end
end
