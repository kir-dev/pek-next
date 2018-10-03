require 'date'

class Metascorer
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def initialize
    @config = Rails.configuration.x.metascoring # Rails config is not threadsafe
  end

  def perform(user_id)
    current_user = User.find(user_id)

    current_user.update(metascore: calculate_meta_score(current_user))
  end

  def calculate_meta_score(user)
    metascore = 0;
    last_sem_point = PointHistory.find_by(usr_id: user.id, semester: SystemAttribute.semester.previous.to_s)
    last_year_point = PointHistory.find_by(usr_id: user.id, semester: SystemAttribute.semester.previous.previous.to_s)
    if(last_sem_point)
      metascore += last_sem_point.point * @config[:last_semester_multiplier]
    end
    if(last_year_point)
      metascore += last_year_point.point * @config[:last_year_multiplier]
    end
    if !user.photo_path.nil?
      metascore += @config[:photo_reward]
    end
    if !user.last_login.nil?
      metascore += last_login_reward(user.last_login)
    end
    if !user.cell_phone.nil?
      metascore += @config[:phone_number_reward]
    end
    if !user.dormitory.nil?
      metascore += @config[:dormitory_reward]
    end
    if !user.email.nil?
      metascore += @config[:email_reward]
    end
    return metascore
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
