require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:babhamozo_leader)
    request.env['HTTP_REFERER'] = "http://test.host/groups/1"
  end

  test "successful new member in group" do
    login_as_user(:non_babhamozo_member)
    assert_difference('Membership.count', 1) do
      post :create, group_id: groups(:babhamozo).id
    end

    assert_redirected_to :back
  end

  test "unauthorized if already member of group" do
    assert_difference('Membership.count', 0) do
      post :create, group_id: groups(:babhamozo).id, id: users(:babhamozo_member).id
    end

    assert_template 'application/401'
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

  test "unarchive active_member of group" do
    membership = grp_membership(:active_archived_babhamozo_member)
    Timecop.freeze do
      xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert_nil membership.reload.archived
    end
    assert_response :success
  end

  test "unarchive inactive_member of group" do
    membership = grp_membership(:inactive_archived_babhamozo_member)
    Timecop.freeze do
      xhr :put, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert_nil membership.reload.archived
    end
    assert_response :success
  end

  test "unauthorized archive of member" do
    login_as_user(:non_babhamozo_member)

    xhr :get, :unarchive, format: :js, group_id: groups(:babhamozo).id, membership_id:  grp_membership(:babhamozo_leader_into_group).id

    assert_template 'application/401'
  end

  test "inactivation of a group member" do
    membership = grp_membership(:babhamozo_member_into_group)
    Timecop.freeze do
      xhr :get, :inactivate, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

      assert membership.reload.membership_end.today?
    end
    assert_response :success
  end

  test "reactivation of an inactive member" do
    membership = grp_membership(:inactive_babhamozo_member)
    xhr :get, :reactivate, format: :js, group_id: groups(:babhamozo).id, membership_id: membership.id

    assert_nil membership.reload.membership_end
    assert_response :success
  end
end
