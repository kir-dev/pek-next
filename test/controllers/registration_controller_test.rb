require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  setup do
    session[:oauth_data] = {
      'internal_id' => 'abc',
      'mail' => 'abc@def.gh',
      'givenName' => 'Károly',
      'sn' => 'Alma'
    }
  end

  test 'show registration page' do
    get :new

    assert_response :success
  end

  test 'unsuccessful registration with existing screen_name' do
    post :create, user: { screen_name: 'sanyi92' }

    assert_response :success
    refute assigns(:user).valid?
  end

  test 'unsuccessful registration with invalid screen_name' do
    post :create, user: { screen_name: 'Feri/Ferko' }

    assert_response :success
    refute assigns(:user).valid?
  end

  test 'registration creates new user' do
    assert_difference('User.count', 1) do
      post :create, user: { screen_name: 'karoly123' }
    end
  end

  test 'successful registration redirects to root' do
    post :create, user: { screen_name: 'karoly123' }

    assert_redirected_to root_url
  end

  test 'successful registration gives flash notice' do
    post :create, user: { screen_name: 'karoly123' }

    assert_equal I18n.t(:register_successful), flash[:notice]
  end
end
