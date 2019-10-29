require 'test_helper'

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  oauth_data = {
    'internal_id' => 'abc',
    'mail' => 'abc@def.gh',
    'givenName' => 'Károly',
    'sn' => 'Alma'
  }

  test 'show registration page' do
    get '/register'

    assert_response :success
  end

  test 'unsuccessful registration with existing screen_name' do
    skip 'Modifying session is not allowed'
    post '/register/create', params: { user: { screen_name: 'sanyi92' } },
                             session: { oauth_data: oauth_data }

    assert_response :success
    refute assigns(:user).valid?
  end

  test 'unsuccessful registration with invalid screen_name' do
    skip 'Modifying session is not allowed'
    post '/register/create', params: { user: { screen_name: 'Feri/Ferko' } },
                             session: { oauth_data: oauth_data }
    assert_response :success
    refute assigns(:user).valid?
  end

  test 'registration creates new user' do
    assert_difference('User.count', 1) do
      skip 'Modifying session is not allowed'
      post '/register/create', params: { user: { screen_name: 'karoly123' } },
                               session: { oauth_data: oauth_data }
    end
  end

  test 'successful registration redirects to root' do
    skip 'Modifying session is not allowed'
    post '/register/create', params: { user: { screen_name: 'karoly123' } },
                             session: { oauth_data: oauth_data }

    assert_redirected_to root_url
  end

  test 'successful registration gives flash notice' do
    skip 'Modifying session is not allowed'
    post '/register/create', params: { user: { screen_name: 'karoly123' } },
                             session: { oauth_data: oauth_data }

    assert_equal I18n.t(:register_successful), flash[:notice]
  end
end
