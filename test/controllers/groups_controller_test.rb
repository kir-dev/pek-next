require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:sanyi)
  end

  test "show groups list" do
    get :index

    assert_equal 20, assigns(:groups).size
    assert_equal groups(:babhamozo).id, assigns(:groups).first.id
  end

  test "show some group" do
    get :show, id: groups(:babhamozo).id

    assert_response :success
    assert_equal groups(:babhamozo).id, assigns(:group).id
  end
end
