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
    @work_point_average ||= average(work_point_sum, eligible_user_count(:work))
  end

  def responsibility_point_average
    @responsibility_point_average ||= average(responsibility_point_sum, eligible_user_count(:responsibility))
  end

  def all_point_average
    @all_point_average ||= average(all_point_sum, eligible_user_count(:all))
  end

  private

  def eligible_user_count(category)
    users.count { |user| user.send("sum_#{category}_point").positive? }
  end

  def average(sum, count)
    return 0 if count.zero?

    (sum.to_f / count).round(2)
  end
end
