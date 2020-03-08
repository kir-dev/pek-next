require 'test_helper'

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_user(:babhamozo_leader)
    Rails.application.env_config['HTTP_REFERER'] = 'http://test.host/groups/1'
  end

  test 'successful new member in group' do
    login_as_user(:non_babhamozo_member)
    current_user = users(:non_babhamozo_member)
    babhamozo_group = groups(:babhamozo)

    assert_nil(current_user.membership_for(babhamozo_group))

    post "/groups/#{babhamozo_group.id}/memberships"
    current_user.memberships.reload

    assert_equal(1, babhamozo_group.leader.user.notifications.count)
    assert_not_nil(current_user.membership_for(babhamozo_group))
    assert_redirected_to :back
  end

  test 'forbidden if already member of group' do
    group = groups(:babhamozo)
    user = users(:babhamozo_member)

    assert_not_nil Membership.find_by(group: group, user: user)

    post "/groups/#{group.id}/memberships"
    assert_equal Membership.where(group: group, user: user).count, 1

    assert_response :forbidden
  end

  test 'archive active_member of group' do
    membership = membership(:newbie_membership)
    Timecop.freeze do
      put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/archive", xhr: true

      assert membership.reload.archived.today?
    end
    assert_response :success
  end

  test 'archive inactive_member of group' do
    membership = membership(:inactive_babhamozo_member)
    Timecop.freeze do
      put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/archive", xhr: true

      assert membership.reload.archived.today?
    end
    assert_response :success
  end

  test 'unarchive active_member of group with group leader' do
    membership = membership(:active_archived_babhamozo_member)

    put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/unarchive", xhr: true

    assert_response :forbidden
  end

  test 'unarchive inactive_member of group with group leader' do
    membership = membership(:inactive_archived_babhamozo_member)

    put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/unarchive", xhr: true

    assert_response :forbidden
  end

  test 'unarchive active_member of group' do
    login_as_user(:pek_admin)
    membership = membership(:active_archived_babhamozo_member)

    put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/unarchive", xhr: true

    assert_response :success
  end

  test 'unarchive inactive_member of group' do
    login_as_user(:pek_admin)
    membership = membership(:inactive_archived_babhamozo_member)

    put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/unarchive", xhr: true

    assert_response :success
  end

  test 'forbidden archive of member' do
    login_as_user(:non_babhamozo_member)
    membership = membership(:babhamozo_leader_into_group)
    put "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/unarchive", xhr: true

    assert_response :forbidden
  end

  test 'inactivation of a group member' do
    membership = membership(:babhamozo_member_into_group)
    Timecop.freeze do
      post "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/inactivate", xhr: true

      assert membership.reload.end_date.today?
    end
    assert_response :success
  end

  test 'reactivation of an inactive member' do
    membership = membership(:inactive_babhamozo_member)
    post "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/reactivate", xhr: true

    assert_nil membership.reload.end_date
    assert_response :success
  end

  test 'delegation became false when inactivate a group member who delegated that group' do
    membership = membership(:babhamozo_member_who_delegated)

    assert membership.user.delegated
    assert_equal(membership.user.primary_membership, membership)

    Timecop.freeze do
      membership.id
      post "/groups/#{groups(:babhamozo).id}/memberships/#{membership.id}/inactivate", xhr: true

      assert_not membership.reload.user.delegated
    end
    assert_response :success
  end
end
