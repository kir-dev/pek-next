require 'test_helper'

class PostTypeTest < ActiveSupport::TestCase
  test 'save' do
    post_type = PostType.new
    post_type.name = 'fontos'

    assert post_type.valid?
    assert post_type.save
  end

  test 'save fails without name' do
    post_type = PostType.new

    assert_not post_type.valid?
    assert_not post_type.save
  end
end
