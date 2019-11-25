require 'test_helper'

module Admin
  class SvieControllerTest < ActionDispatch::IntegrationTest
    test 'applications page enabled for rvt members' do
      login_as_user(:rvt_member)
      get '/admin/svie'
      assert_response :success
    end

    test 'applications page forbidden for not rvt members' do
      login_as_user(:not_rvt_member)
      get '/admin/svie'
      assert_response :forbidden
    end
  end
end
