require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  test "profile photo path"
    assert raw_path("test") == "asd"
  end
end
