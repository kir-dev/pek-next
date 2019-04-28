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
    membership = membership(:newbie_membership)

    assert membership.newbie?
    assert_not membership.new_member?

    membership.accept!
    membership.reload

    assert_not membership.newbie?
    assert membership.new_member?
  end

  test 'accepting membership notifies user' do
    membership = membership(:newbie_membership)
    expect_any_instance_of(Membership).to receive(:notify).and_call_original

    membership.accept!
    assert_equal(1, membership.user.notifications.count)
  end

  test 'inactivating membership notifies user' do
    membership = membership(:babhamozo_member_into_group)
    expect_any_instance_of(Membership).to receive(:notify).and_call_original

    membership.inactivate!
    assert_equal(1, membership.user.notifications.count)
  end

  test 'archiving membership notifies user' do
    membership = membership(:babhamozo_member_into_group)
    expect_any_instance_of(Membership).to receive(:notify).and_call_original

    membership.archive!
    assert_equal(1, membership.user.notifications.count)
  end
end
