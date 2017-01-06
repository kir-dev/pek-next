require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  setup do
    login_as_user(10)
  end

  test "show own profile" do
    get :show_self
    assert_response :success
    assert_equal 10, assigns(:user).usr_id
  end

  test "show some other users' profile" do
    get :show, id: 11
    assert_response :success
    assert_equal 11, assigns(:user).usr_id
  end

end
