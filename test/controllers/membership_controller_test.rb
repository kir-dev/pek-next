require 'test_helper'

class MembershipControllerTest < ActionController::TestCase
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

  test "deleting member of group" do
    assert_difference('Membership.count', -1) do
      delete :destroy, format: :js, group_id: groups(:babhamozo).id, id: grp_membership(:babhamozo_member_into_group).id
    end

    assert_response :success
  end

  test "unauthorized deletion of member" do
    login_as_user(:non_babhamozo_member)
    assert_difference('Membership.count', 0) do
      delete :destroy, group_id: groups(:babhamozo).id, id: grp_membership(:babhamozo_leader_into_group).id
    end

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
