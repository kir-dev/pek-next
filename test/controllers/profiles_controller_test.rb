require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    login_as_user(:sanyi)
  end

  test "show own profile" do
    get :show_self

    assert_response :success
    assert_equal users(:sanyi).id, assigns(:user_presenter).id
  end

  test "show some other users' profile" do
    get :show, id: users(:bela).screen_name

    assert_response :success
    assert_equal users(:bela).id, assigns(:user_presenter).id
  end

  test "rendering edit page is successful" do
    get :edit, id: users(:bela).screen_name

    assert_response :success
    assert_equal users(:bela).id, assigns(:user).id
  end

  test "update user is successful" do
    user = users(:sanyi)

    patch :update, id: user.screen_name, profile: { firstname: "Happy" }

    assert_equal "Happy", user.reload.firstname
  end

  test "successful update redirects to profile" do
    user = users(:sanyi)

    patch :update, id: user.screen_name, profile: { firstname: "Happy" }

    assert_redirected_to profiles_me_path
  end
end
