Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if ENV['NONAUTH']
  provider :oauth, ENV['APP_ID'], ENV['APP_SECRET'], scope: 'basic displayName mail'
end