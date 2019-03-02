Unsplash.configure do |config|
  return if Rails.env.test?

  config.application_access_key = ENV.fetch('UNSPLASH_ACCES_KEY')
  config.application_secret = ENV.fetch('UNSPLASH_SECRET')
  config.utm_source = 'pek_error_images'
end
