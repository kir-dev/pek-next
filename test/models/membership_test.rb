require 'test_helper'

class MembershipTest < ActionController::TestCase
  test "delegation became false when archive" do
    membership = grp_membership(:babhamozo_member_who_delegated)
    assert membership.user.delegated
    membership.archive!

    assert_not membership.reload.user.delegated
  end

  test 'delegation became false when inactivate' do
    membership = grp_membership(:babhamozo_member_who_delegated)
    assert membership.user.delegated
    membership.inactivate!

    assert_not membership.reload.user.delegated
  end
end