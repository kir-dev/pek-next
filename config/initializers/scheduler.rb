require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.cron '00 04 * * *' do
  Rails.logger.info("Started user metascoring")
  all_users = User.select('id')
  all_users.each do |user|
    Metascorer.perform_async(user.id);
  end
  Rails.logger.info("Metascoring jobs sent to Sidekiq")
end
