ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as_user(user_name)
    session[:user_id] = users(user_name).id
  end
end

class SidekiqTestCase < ActiveSupport::TestCase
  setup do
    Sidekiq::Testing.fake!
    Sidekiq::Worker.clear_all
  end
end
