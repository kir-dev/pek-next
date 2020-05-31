require 'test_helper'

class SvieControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as_user(:user_with_primary_membership)
  end

  test 'correctly show edit page' do
    get '/svie/edit'

    assert_response :success
    assert_equal 3, assigns(:svie_memberships).size
    assert_equal membership(:user_with_primary_membership).id,
                 assigns(:svie_memberships).first.id
    assert_equal membership(:newbie_membership).id, assigns(:svie_memberships).last.id
  end

  test 'save change of primary group' do
    params = { svie: { primary_membership: membership(:not_primary_membership).id } }
    post '/svie/update', params: params

    assert_redirected_to profiles_me_path
    assert_equal membership(:not_primary_membership).id,
                 users(:user_with_primary_membership).reload.svie_primary_membership
  end
end
