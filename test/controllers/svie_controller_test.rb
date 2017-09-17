require 'test_helper'

class SvieControllerTest < ActionController::TestCase
  setup do
    login_as_user(:user_with_primary_membership)
  end

  test "correctly show edit page" do
    get :edit

    assert_response :success
    assert_equal 2, assigns(:svie_memberships).size
    assert_equal grp_membership(:user_with_primary_membership).id, assigns(:svie_memberships).first.id
    assert_equal grp_membership(:not_primary_membership).id, assigns(:svie_memberships).last.id
  end

  test "save change of primary group" do
    post :update, svie: { primary_membership: grp_membership(:not_primary_membership).id}

    assert_redirected_to profiles_me_path
    assert_equal grp_membership(:not_primary_membership).id, users(:user_with_primary_membership).reload.svie_primary_membership
  end
end
