require 'date'

class Metascorer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
    @config = Rails.configuration.x.metascoring # Rails config is not threadsafe
  end

  def perform(user_id)
    current_user = User.find(user_id)

    current_user.update(metascore: calculate_meta_score(current_user))
  end

  def calculate_meta_score(user)
    last_sem_point = PointHistory.find_by(usr_id: user.id, semester: SystemAttribute.semester.previous.to_s)
    last_year_point = PointHistory.find_by(usr_id: user.id, semester: SystemAttribute.semester.previous.previous.to_s)

    metascore = 0

    metascore += last_sem_point.point * @config[:last_semester_multiplier] if last_sem_point
    metascore += last_year_point.point * @config[:last_year_multiplier] if last_year_point
    metascore += @config[:dormitory_reward] if user.dormitory.present?
    metascore += @config[:email_reward] if user.email.present?
    metascore += @config[:phone_number_reward] if user.cell_phone.present?
    metascore += @config[:photo_reward] if user.photo_path.present?
    metascore += last_login_reward(user.last_login) if user.last_login.present?

    metascore
  end

  def last_login_reward(last_login)
    @config[:login_rewards].each do |tier|
      return tier[:reward] if last_login > Date.today - tier[:time]
    end

    0
  end
end
