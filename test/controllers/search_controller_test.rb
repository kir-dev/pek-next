require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    login_as_user(10)
  end

  test "empty search page" do
    get :search
    assert_response :success
  end

  test "suggestion page response" do
    get :suggest
    assert_response :success
  end

  test "search for empty queue" do
    query = SearchQuery.new.search("", nil)
    assert_equal 10, query.size
    assert_equal 11, query.first.usr_id
  end

  test "search in nickname" do
    query = SearchQuery.new.search("sanyi", nil)
    assert_equal 1, query.size
    assert_equal 10, query.first.usr_id
  end

  test "search in last+firstname" do
    query = SearchQuery.new.search("Kovács Béla", nil)
    assert_equal 1, query.size
    assert_equal 11, query.first.usr_id
  end

  test "next search page of generated users" do
    query = SearchQuery.new.search("pék", 1)
    assert_equal 10, query.size
    assert_equal 289, query.first.usr_id
  end

  test "search for non-existent user" do
    query = SearchQuery.new.search("gergely", nil)
    assert_equal 0, query.size
  end

end
