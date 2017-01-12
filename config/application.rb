require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PekNext
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :hu

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.schema_format = :sql

    config.x.dorms = [ "Schönherz Zoltán Kollégium", "Nagytétényi úti Kollégium", "Vásárhelyi", "Kármán", "Külsős" ]
    config.x.results_per_page = 10
    config.x.metascoring = {
      last_semester_multiplier: 5,
      last_year_multiplier: 5,
      photo_reward: 500,
      phone_number_reward: 300,
      dormitory_reward: 300,
      email_reward: 200,
      login_rewards: [
        { time: 7, reward: 650 },
        { time: 30, reward: 450 },
        { time: 90, reward: 250 },
        { time: 180, reward: 100 },
        { time: 360, reward: 50 }
      ]
    }
  end
end
