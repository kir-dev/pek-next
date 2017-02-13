require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  setup do
    login_as_user(:sanyi)
  end

  test "show own profile" do
    get :show_self
    assert_response :success
    assert_equal users(:sanyi).id, assigns(:user).id
  end

  test "show some other users' profile" do
    get :show, id: users(:bela).id
    assert_response :success
    assert_equal users(:bela).id, assigns(:user).id
  end

end
