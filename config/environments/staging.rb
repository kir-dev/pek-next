# Just use the production settings
require File.expand_path('../production.rb', __FILE__)

Rails.application.configure do
  # Here override any defaults
  routes.default_url_options[:host] = 'pek.staging.kir-dev.sch.bme.hu'

  config.ssl_options = { redirect: { host: 'pek.staging.kir-dev.sch.bme.hu' } }
end
