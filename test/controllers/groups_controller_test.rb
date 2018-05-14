require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    login_as_user(:sanyi)
  end

  test "show all groups list" do
    result_per_page = 20
    get :all, per: result_per_page

    assert_equal result_per_page, assigns(:groups).size
    assert_equal groups(:babhamozo).id, assigns(:groups).first.id
  end

  test "show active groups list" do
    time = Time.now() + 2.year
    semester = "#{time.year}#{time.year+1}1"
    SystemAttribute.update_semester(semester)
    get :index, per: 20

    assert_equal 0, assigns(:groups).size
  end

  test "show some group" do
    get :show, id: groups(:babhamozo).id

    assert_response :success
    assert_equal groups(:babhamozo).id, assigns(:viewmodel).group.id
  end

  test "unauthorized access to edit page" do
    get :edit, id: groups(:babhamozo).id

    assert_template 'application/401'
  end

  test "unauthorized save after editing" do
    get :update, id: groups(:babhamozo).id

    assert_template 'application/401'
  end

  test "render edit page for leaders" do
    login_as_user(:babhamozo_leader)
    get :edit, id: groups(:babhamozo).id

    assert_response :success
    assert_template 'groups/edit'
  end

  test "save edited group" do
    login_as_user(:babhamozo_leader)
    group = groups(:babhamozo)

    patch :update, id: group.id, group: { description: "babot hámoznak" }

    assert_redirected_to group_path(group)
    assert_equal "babot hámoznak", group.reload.description
  end
end
