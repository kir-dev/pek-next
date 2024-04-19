

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') }

  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file)
      schedule = YAML.load_file(schedule_file)

      Sidekiq::Cron::Job.load_from_hash!(schedule)
    end
  end
end
