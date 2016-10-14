require 'date'

class Metascorer
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(user_id)
    current_user = User.find(user_id)
    metascore = 0;
    if !current_user.photo_path.nil?
      metascore += 500
    end
    if !current_user.lastlogin.nil?
      metascore += last_login_reward(current_user.lastlogin)
    end
    if !current_user.cell_phone.nil?
      metascore += 300
    end
    if !current_user.dormitory.nil?
      metascore += 300
    end
    if !current_user.email.nil?
      metascore += 200
    end
    current_user.metascore = metascore
    current_user.save
  end

  def last_login_reward(last_login)
    login_rewards = [{ time: 7, reward: 650 },
    { time: 30, reward: 450 },
    { time: 90, reward: 250 },
    { time: 180, reward: 100 },
    { time: 360, reward: 50 }]

    login_rewards.each do |tier|
      if last_login > Date.today - tier[:time]
        return tier[:reward]
      end
    end
    return 0
  end
end
