require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
  # test 'test cellphone format invalid' do
  #   user = users(:sanyi)
  #   user.cell_phone = 'asdf'

  #   refute user.valid?
  #   refute_empty user.errors[:cell_phone]
  # end

  test 'test cellphone format valid' do
    user = create(:user)

    user.cell_phone = '+36201234567'

    assert user.valid?
    assert_empty user.errors[:cell_phone]
  end

  test 'test cellphone can be empty' do
    user = create(:user)
    user.cell_phone = ''

    assert user.valid?
    assert_empty user.errors[:cell_phone]
  end

  test 'membership for group' do
    assert true # TODO
  end

  test 'when primary membership id not definied' do
    membership = create(:user).primary_membership
    assert_nil membership
  end

  test 'nickname of 30 characters is valid' do
    user = create(:user)
    user.nickname = 'á' * User::NICKNAME_MAX_LENGTH

    assert user.valid?
    assert_empty user.errors[:nickname]
  end

  test 'nickname longer than 30 characters is invalid' do
    user = create(:user)
    user.nickname = 'a' * (User::NICKNAME_MAX_LENGTH + 1)

    refute user.valid?
    assert_includes user.errors[:nickname], 'legfeljebb 30 karakter lehet!'
  end

  test 'blank nickname is valid' do
    user = create(:user)
    user.nickname = ''

    assert user.valid?
    assert_empty user.errors[:nickname]
  end
end
