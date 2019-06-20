# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

abort 'Running in production env' if Rails.env.production?

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.render_views
end
