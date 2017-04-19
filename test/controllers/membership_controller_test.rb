require 'test_helper'

class MembershipControllerTest < ActionController::TestCase
  setup do
    login_as_user(:babhamozo_leader)
    request.env['HTTP_REFERER'] = "http://test.host/groups/1"
  end

  test "successful new member in group" do
    assert_difference('Membership.count', 1) do
      post :create, group_id: groups(:babhamozo).id, id: users(:non_babhamozo_member).id
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
      delete :destroy, group_id: groups(:babhamozo).id, id: users(:babhamozo_member).id
    end

    assert_redirected_to group_path(groups(:babhamozo).id)
  end

  test "unauthorized deletion of member" do
  end

  test "inavtivation of a group member" do
  end

  test "reactivation of an inactive member" do
  end
end
