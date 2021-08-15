class EvaluationPointCalculator
  attr_reader :users

  def initialize(users)
    @users = users
  end

  def work_point_sum
    @work_point_sum ||= users.sum(&:sum_work_point)
  end

  def responsibility_point_sum
    @responsibility_point_sum ||= users.sum(&:sum_responsibility_point)
  end

  def all_point_sum
    @all_point_sum ||= users.sum(&:sum_all_point)
  end

  def work_point_average
    @work_point_average ||= average(work_point_sum, user_count)
  end

  def responsibility_point_average
    @responsibility_point_average ||= average(responsibility_point_sum, user_count)
  end

  def all_point_average
    @all_point_average ||= average(all_point_sum, user_count)
  end

  def work_details_average
    @work_details_average ||= average(work_point_sum, eligible_user_count(:work))
  end

  def responsibility_details_average
    @responsibility_details_average ||= average(responsibility_point_sum, eligible_user_count(:responsibility))
  end

  def all_details_average
    @all_details_average ||= average(all_point_sum, eligible_user_count(:all))
  end

  def principle_sum(principle)
    point_details.select { |pd| pd.principle_id == principle.id }.sum(&:point)
  end

  def principle_average(principle)
    sum = principle_sum(principle)
    count = user_count
    average(sum, count)
  end

  def principle_details_average(principle)
    sum = principle_sum(principle)
    count = principle_details_count(principle)
    average(sum, count)
  end

  private

  def principle_details_count(principle)
    point_details.select { |pd| pd.principle_id == principle.id && !pd.point.zero? }.count
  end

  def user_count
    @user_count ||= users.count
  end

  def point_details
    @point_details ||= users.map(&:point_details).flatten.compact
  end

  def eligible_user_count(category)
    users.count { |user| user.send("sum_#{category}_point").positive? }
  end

  def average(sum, count)
    return 0 if count.zero?

    (sum.to_f / count).round(2)
  end
end
