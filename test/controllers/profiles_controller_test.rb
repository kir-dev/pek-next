require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_user(:sanyi)
  end

  test 'show own profile' do
    get "/profiles/#{users(:sanyi).screen_name}"

    assert_response :success
    assert_equal users(:sanyi).id, assigns(:user_presenter).id
  end

  test 'show some other users\' profile' do
    get "/profiles/#{users(:bela).screen_name}"

    assert_response :success
    assert_equal users(:bela).id, assigns(:user_presenter).id
  end

  test 'redirects to own profile at invalid screenname' do
    get '/profiles/dummy'

    assert_response :redirect
    assert_redirected_to profiles_me_path
  end

  test 'rendering edit page is successful' do
    get "/profiles/#{users(:sanyi).screen_name}"

    assert_response :success
    assert_equal users(:sanyi).id, assigns(:user_presenter).id
  end

  test 'update user is successful' do
    user = users(:sanyi)

    patch "/profiles/#{user.screen_name}", profile: { firstname: 'Happy' }

    assert_equal 'Happy', user.reload.firstname
  end

  test 'successful update redirects to profile' do
    user = users(:sanyi)

    patch "/profiles/#{user.screen_name}", profile: { firstname: 'Happy' }

    assert_redirected_to profiles_me_path
  end
end
