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

    assert_template 'application/401'
  end

  test "deleting member of group" do
    babhamozo_member_into_group = grp_membership(:babhamozo_member_into_group)

    assert_not_nil Membership.find(babhamozo_member_into_group.id)
      delete :destroy, format: :js, group_id: groups(:babhamozo).id,
        id: babhamozo_member_into_group.id
    assert_nil Membership.find_by(id: babhamozo_member_into_group.id)

    assert_response :success
  end

  test "unauthorized deletion of member" do
    login_as_user(:non_babhamozo_member)

    babhamozo_member_membership = grp_membership(:babhamozo_leader_into_group)

    assert_not_nil Membership.find(babhamozo_member_membership.id)
      delete :destroy, group_id: groups(:babhamozo).id,
        id: babhamozo_member_membership.id
    assert_not_nil Membership.find(babhamozo_member_membership.id)

    assert_template 'application/401'
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
end
