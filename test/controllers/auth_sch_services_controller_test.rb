require 'test_helper'

class AuthSchServicesControllerTest < ActionController::TestCase
  test 'basic data with invalid id' do
    get :sync, id: 'invalidid'

    assert_response :bad_request
    resp_json = JSON.parse response.body
    assert_equal false, resp_json['success']
    assert_equal I18n.t(:invalid_id), resp_json['message']
  end

  test 'basic data with non-existing id' do
    get :sync, id: 'ASDBSD'

    assert_response :not_found
    resp_json = JSON.parse response.body
    assert_equal false, resp_json['success']
    assert_equal I18n.t(:non_existent_id, id: 'ASDBSD'), resp_json['message']
  end

  test 'basic data with correct neptun' do
    get :sync, id: users(:sanyi).neptun

    assert_response :success
    resp_json = JSON.parse response.body
    expected_user = {
      'displayName' => users(:sanyi).lastname + ' ' + users(:sanyi).firstname,
      'mail' => users(:sanyi).email,
      'givenName' => users(:sanyi).firstname,
      'sn' => users(:sanyi).lastname,
      'eduPersonNickName' => users(:sanyi).nickname,
      'uid' => users(:sanyi).screen_name,
      'mobile' => users(:sanyi).cell_phone,
      'schacPersonalUniqueId' => users(:sanyi).id
    }
    assert_equal true, resp_json['success']
    assert_equal expected_user, resp_json['user']
  end

  test 'memberships with correct auth.sch id' do
    get :memberships, id: users(:babhamozo_member).auth_sch_id

    assert_response :success
    resp_json = JSON.parse response.body
    expected_response = [
      {
        'start' => '2010-02-02',
        'end' => grp_membership(:babhamozo_member_into_group).end_date,
        'group_name' => groups(:babhamozo).name,
        'group_id' => groups(:babhamozo).id,
        'posts' => ['tag']
      }
    ]
    assert_equal true, resp_json['success']
    assert_equal expected_response, resp_json['memberships']
  end

  test 'entrants for a single semester and user' do
    get :entrants, semester: evaluations(:babhamozo_2018).semester,
                   id: users(:babhamozo_member).auth_sch_id

    assert_response :success
    resp_json = JSON.parse response.body
    expected_response = [
      {
        'groupId' => groups(:babhamozo).id,
        'groupName' => groups(:babhamozo).name,
        'entrantType' => entry_requests(:babhamozo_member_2018).entry_type
      }
    ]
    assert_equal expected_response, resp_json
  end
end
