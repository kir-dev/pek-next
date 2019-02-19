require 'test_helper'

module Admin
  class SvieControllerTest < ActionController::TestCase
    test 'applications page enabled for rvt members' do
      login_as_user(:rvt_member)
      get :index
      assert_response :success
    end

    test 'applications page forbidden for not rvt members' do
      login_as_user(:not_rvt_member)
      get :index
      assert_response :forbidden
    end
  end
end
