require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:sanyi)
  end

  test "show groups list" do
    result_per_page = 20
    get :index, per: result_per_page

    assert_equal result_per_page, assigns(:groups).size
    assert_equal groups(:babhamozo).id, assigns(:groups).first.id
  end

  test "show some group" do
    get :show, id: groups(:babhamozo).id

    assert_response :success
    assert_equal groups(:babhamozo).id, assigns(:viewmodel).group.id
  end
end
