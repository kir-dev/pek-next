require 'date'

class Metascorer
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def initialize
    @config = Rails.configuration.x.metascoring # Rails config is not threadsafe
  end

  def perform(user_id)
    Thread.current[:config] = Rails.configuration.x.metascoring
    current_user = User.find(user_id)
    metascore = 0;
    last_sem_point = PointHistory.find_by(usr_id: user_id, semester: SystemAttr.semester.previous.to_s)
    last_year_point = PointHistory.find_by(usr_id: user_id, semester: SystemAttr.semester.previous.previous.to_s)
    if(last_sem_point)
      metascore += last_sem_point.point * @config[:last_semester_multiplier]
    end
    if(last_year_point)
      metascore += last_year_point.point * @config[:last_year_multiplier]
    end
    if !current_user.photo_path.nil?
      metascore += @config[:photo_reward]
    end
    if !current_user.lastlogin.nil?
      metascore += last_login_reward(current_user.lastlogin)
    end
    if !current_user.cell_phone.nil?
      metascore += @config[:phone_number_reward]
    end
    if !current_user.dormitory.nil?
      metascore += @config[:dormitory_reward]
    end
    if !current_user.email.nil?
      metascore += @config[:email_reward]
    end
    current_user.metascore = metascore
    current_user.save
  end

  def last_login_reward(last_login)
    @config[:login_rewards].each do |tier|
      if last_login > Date.today - tier[:time]
        return tier[:reward]
      end
    end
    return 0
  end
end
