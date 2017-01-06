require 'sidekiq/testing'

class MetascoreTest < ActionController::TestCase

  setup do
    Sidekiq::Testing.fake!
  end

  test "metascoring jobs are queued" do
    Metascorer.jobs.clear
    Metascorer.perform_async(11)
    assert_equal 1, Metascorer.jobs.size
  end

  test "every user is sent for metascoring" do
    Metascorer.jobs.clear
    MetascoreEveryone.perform_async
    MetascoreEveryone.drain
    assert_equal User.all.size, Metascorer.jobs.size
  end

  test "a test user gets 0 metascore" do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(240)
      assert_equal 0, User.find(240).metascore
    end
  end

  test "metascore algorithm testing for only phone number" do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(3000)
      assert_equal Rails.configuration.x.metascoring[:phone_number_reward], User.find(3000).metascore
    end
    User.find(3000).update(metascore: 0)
  end

  test "metascore algorithm testing for profile" do
    Sidekiq::Testing.inline! do
      Metascorer.perform_async(3001)
      profile_rewards = Rails.configuration.x.metascoring[:photo_reward] +
        Rails.configuration.x.metascoring[:dormitory_reward] +
        Rails.configuration.x.metascoring[:email_reward]
      assert_equal profile_rewards, User.find(3001).metascore
    end
    User.find(3001).update(metascore: 0)
  end

end
