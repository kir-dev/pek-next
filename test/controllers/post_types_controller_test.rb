require 'test_helper'

class PostTypesControllerTest < ActionController::TestCase
  setup do
    login_as_user(:babhamozo_leader)
    request.env['HTTP_REFERER'] = 'http://test.host/groups/1'
  end

  test 'redirect back at new post type' do
    post :create, group_id: groups(:babhamozo).id, post_type: { name: 'fontos' }

    assert_redirected_to :back
  end

  test 'new post type creates actual post type' do
    post_type_count = PostType.count
    post :create, group_id: groups(:babhamozo).id, post_type: { name: 'fontos' }

    assert_equal post_type_count + 1, PostType.count
  end

  test 'new post type with empty name redirects back with error message' do
    post :create, group_id: groups(:babhamozo).id, post_type: { name: '' }

    assert_redirected_to :back
    assert_not_empty flash[:alert]
  end

  test 'return forbidden for creating post type for other group' do
    post :create, group_id: groups(:group0).id, post_type: { name: 'fontos' }

    assert_response :forbidden
  end

  test 'return forbidden for creating post type as non leader' do
    login_as_user(:babhamozo_member)
    post :create, group_id: groups(:babhamozo).id, post_type: { name: 'fontos' }

    assert_response :forbidden
  end
end
