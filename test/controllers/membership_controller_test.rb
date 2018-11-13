require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:babhamozo_leader)
    request.env['HTTP_REFERER'] = "http://test.host/groups/1"
  end

  test "successful new member in group" do
    login_as_user(:non_babhamozo_member)
    current_user = users(:non_babhamozo_member)
    babhamozo_group = groups(:babhamozo)

    assert_nil(current_user.membership_for(babhamozo_group))

    post :create, group_id: babhamozo_group.id
    current_user.memberships.reload

    assert_not_nil(current_user.membership_for(babhamozo_group))
    assert_redirected_to :back
  end

  test "unauthorized if already member of group" do
    group_and_user_ids_hash = { group_id: groups(:babhamozo).id,
                                user_id: users(:babhamozo_member).id }

    assert_not_nil Membership.find_by( group_and_user_ids_hash )
    post :create, group_and_user_ids_hash
    assert_equal Membership.where( group_and_user_ids_hash ).count, 1

    assert_response :unauthorized
  end

  test "archive active_member of group" do
    membership = grp_membership(:newbie_membership)
    Timecop.freeze do
      xhr :put, :archive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert membership.reload.archived.today?
    end
    assert_response :success
  end

  test "archive inactive_member of group" do
    membership = grp_membership(:inactive_babhamozo_member)
    Timecop.freeze do
      xhr :put, :archive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert membership.reload.archived.today?
    end
    assert_response :success
  end

  test "unarchive active_member of group with group leader" do
    membership = grp_membership(:active_archived_babhamozo_member)

    xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

    assert_response :unauthorized
  end

  test "unarchive inactive_member of group with group leader" do
    membership = grp_membership(:inactive_archived_babhamozo_member)

    xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

    assert_response :unauthorized
  end

  test "unarchive active_member of group" do
    login_as_user(:pek_admin)
    membership = grp_membership(:active_archived_babhamozo_member)

    xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

    assert_response :success
  end

  test "unarchive inactive_member of group" do
    login_as_user(:pek_admin)
    membership = grp_membership(:inactive_archived_babhamozo_member)

    xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

    assert_response :success
  end

  test "unauthorized archive of member" do
    login_as_user(:non_babhamozo_member)

    xhr :get, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id:  grp_membership(:babhamozo_leader_into_group).id

    assert_response :unauthorized
  end

  test "inactivation of a group member" do
    membership = grp_membership(:babhamozo_member_into_group)
    Timecop.freeze do
      xhr :get, :inactivate, format: :js, group_id: groups(:babhamozo).id,
        membership_id: membership.id

      assert membership.reload.membership_end.today?
    end
    assert_response :success
  end

  test "reactivation of an inactive member" do
    membership = grp_membership(:inactive_babhamozo_member)
    xhr :get, :reactivate, format: :js, group_id: groups(:babhamozo).id,
      membership_id: membership.id

    assert_nil membership.reload.membership_end
    assert_response :success
  end

  test "delegation became false when inactivate a group member who delegated that group" do
    membership = grp_membership(:babhamozo_member_who_delegated)

    assert membership.user.delegated
    assert_equal(membership.user.primary_membership, membership)

    Timecop.freeze do
      xhr :get, :inactivate, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert_not membership.reload.user.delegated
    end
    assert_response :success
  end
end
