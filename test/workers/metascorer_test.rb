require 'sidekiq/testing'

class MetascoreTest < SidekiqTestCase
  test 'every user is sent for metascoring' do
    MetascoreEveryone.new.perform
    assert_equal User.all.size, Metascorer.jobs.size
  end

  test 'a test user gets 0 metascore' do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(users(:user_40).id)
      assert_equal 0, User.find(users(:user_40).id).metascore
    end
  end

  test 'metascore algorithm testing for only phone number' do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(users(:metascore_1).id)
      assert_equal Rails.configuration.x.metascoring[:phone_number_reward],
                   User.find(users(:metascore_1).id).metascore
    end
    User.find(users(:metascore_1).id).update(metascore: 0)
  end

  test 'metascore algorithm testing for profile' do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(users(:metascore_2).id)
      profile_rewards = Rails.configuration.x.metascoring[:photo_reward] +
                        Rails.configuration.x.metascoring[:dormitory_reward] +
                        Rails.configuration.x.metascoring[:email_reward]
      assert_equal profile_rewards, User.find(users(:metascore_2).id).metascore
    end
    User.find(users(:metascore_2).id).update(metascore: 0)
  end
end
