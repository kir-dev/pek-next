# Just use the production settings
require File.expand_path('../production.rb', __FILE__)

Rails.application.configure do
  # Here override any defaults
  routes.default_url_options[:host] = ENV['HOST_URL']

  config.ssl_options = { redirect: { host: ENV['HOST_URL'] } }
end
