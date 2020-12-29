class EvaluationPointCalculator
  attr_reader :users, :user_count

  def initialize(users)
    @users      = users
    @user_count = users.length.to_f
  end

  def work_point_sum
    @work_point_sum ||= users.sum(&:sum_work_point)
  end

  def responsibility_point_sum
    @responsibility_point_sum ||= users.sum(&:sum_responsibility_point)
  end

  def all_point_sum
    @all_point_sum ||= users.sum(&:sum_point)
  end

  def work_point_average
    @work_point_average ||= average(work_point_sum)
  end

  def responsibility_point_average
    @responsibility_point_average ||= average(responsibility_point_sum)
  end

  def all_point_average
    @all_point_average ||= average(all_point_sum)
  end

  private

  def average(sum)
    return 0 if user_count.zero?

    (sum.to_f / user_count).round(2)
  end
end
