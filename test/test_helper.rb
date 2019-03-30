ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    self.use_transactional_fixtures = true

    set_fixture_class grp_membership: Membership
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_as_user(user_name)
      session[:user_id] = users(user_name).id
    end
  end
end

class SidekiqTestCase < ActiveSupport::TestCase
  setup do
    Sidekiq::Testing.fake!
    Sidekiq::Worker.clear_all
  end
end
