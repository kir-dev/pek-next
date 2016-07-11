Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if ENV['NONAUTH']
  provider :oauth, ENV.fetch('APP_ID'), ENV.fetch('APP_SECRET')
end
