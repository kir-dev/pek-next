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
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :hu

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.schema_format = :sql

    config.x.photo_path = 'public/uploads/'
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
    config.x.dorms = {
      'Nem megadott' => '',
      'Schönherz'    => 'Schönherz Zoltán Kollégium',
      'Tétény'       => 'Nagytétényi úti Kollégium',
      'Kármán'       => 'Kármán Tódor Kollégium',
      'Vásárhelyi'   => 'Vásárhelyi Pál Kollégium',
      'Külsős'       => 'Külsős'
    }
    config.x.genders = {
      'NOTSPECIFIED' => 'Nem megadott',
      'MALE'         => 'Férfi',
      'FEMALE'       => 'Nő',
      'UNKNOWN'      => 'Egyéb'
    }
    config.x.roles = ['mezei_user', 'group_leader', 'rvt_member', 'svie_admin', 'pek_admin']
    config.x.im_accounts = {
      'call_sign'    => 'Hívójel',
      'gtalk'        => 'Google Hangouts',
      'skype'        => 'Skype',
      'irc'          => 'IRC',
      'twitter'      => 'Twitter',
      'facebook'     => 'Facebook',
      'jabber'       => 'Jabber'
    }
    config.x.svie_states = {
      'ELFOGADVA'        => 'Elfogadva',
# Meg van a papírja, az RVT elfogadására vár :
      'FELDOLGOZASALATT' => 'Feldolgozás alatt',
# A papírja leadás alatt van (ide esik, ha a user letölti a belépési nyilatkozatát) :
      'ELFOGADASALATT'   => 'Elfogadás alatt',
      'NEMTAG'           => 'Nem tag'
    }

    # This should be the member types after we no longer depend on old VIR
    # config.x.svie_member_types = {
    #   'RENDESTAG' => 'Rendes tag',
    #   'KULSOSTAG' => 'Külsős tag',
    #   'OREGTAG' => 'Öregtag'
    # }

    # This is temporary pls no merge to master
    config.x.svie_member_types = {
      'RENDESTAG' => 'Rendes tag',
      'PARTOLOTAG' => 'Külsős tag',
    }
    config.x.season_types = {
        'NINCSERTEKELES' => 'Nyugalmi időszak',
        'ERTEKELESLEADAS' => 'Pontozási időszak',
        'ERTEKELESELBIRALAS' => 'Bírálási időszak'
    }
    config.x.principle_types = {
        'WORK' => 'Munka',
        'RESPONSIBILITY' => 'Felelősség'
    }

    config.x.auth_sch_pingback_url = 'https://auth.sch.bme.hu/api/profile/resync?access_token='
    config.x.neptun_regex = /^[A-Za-z0-9]{6,7}$/
    config.x.uuid_regex = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  end
end
