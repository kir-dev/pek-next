require 'test_helper'

class MembershipTest < ActionDispatch::IntegrationTest
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

  test 'accepting removes newbie post and sets new member post' do
    membership = grp_membership(:newbie_membership)

    assert membership.newbie?
    assert_not membership.new_member?

    membership.accept!
    membership.reload

    assert_not membership.newbie?
    assert membership.new_member?
  end
end
