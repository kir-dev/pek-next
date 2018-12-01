class MetascoreEveryone
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Rails.logger.info('Started user metascoring')
    all_users = User.select('id')
    all_users.find_each do |user|
      Metascorer.perform_async(user.id)
    end
    Rails.logger.info('Metascoring jobs sent to Sidekiq')
  end
end
