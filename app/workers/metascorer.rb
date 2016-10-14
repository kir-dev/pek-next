class Metascorer
  include Sidekiq::Worker
  def perform(user_id)
    current_user = User.find(user_id)
    metascore = 0;
    if !current_user.photo_path.nil?
      metascore += 300
    end
    current_user.metascore = metascore
    current_user.save
  end
end
