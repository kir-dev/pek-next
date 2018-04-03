require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    login_as_user(:sanyi)
  end

  test "empty search page" do
    get :search
    assert_response :success
  end

  test "suggestion page response" do
    get :suggest
    assert_response :success
  end

  test "search for empty term" do
    page_size = 10
    query = SearchQuery.new.user_search("", nil, page_size)
    assert_equal page_size, query.size
    expected_result = [users(:bela), users(:sanyi)]
    for result in 2..9 do
      expected_result.push(users("user_" + (101 - result).to_s))
    end
    assert_equal expected_result, query.take(page_size)
  end

  test "search in nickname" do
    query = SearchQuery.new.user_search("sanyi", nil, 10)
    assert_equal 1, query.size
    assert_equal users(:sanyi).id, query.first.id
  end

  test "search in last+firstname" do
    query = SearchQuery.new.user_search("Kovács Béla", nil, 10)
    assert_equal 1, query.size
    assert_equal users(:bela).id, query.first.id
  end

  test "search in groups name" do
    query = SearchQuery.new.group_search("Bab", nil)
    assert_equal 1, query.size
    assert_equal groups(:babhamozo).id, query.first.id
  end

  test "next search page of generated users" do
    page_size = 10
    query = SearchQuery.new.user_search("pék", page_size, page_size)
    assert_equal page_size, query.size
    expected_result = []
    for result in 0..9 do
      expected_result.push(users("user_" + (89 - result).to_s))
    end
    assert_equal expected_result, query.take(page_size)
  end

  test "search for non-existent user" do
    query = SearchQuery.new.user_search("gergely", nil, 10)
    assert_equal 0, query.size
  end

end
