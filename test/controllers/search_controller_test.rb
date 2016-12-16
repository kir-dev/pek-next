require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    session[:user_id] = 10
  end

  test "empty search page" do
    get 'search'
    assert_response :success
  end

end
