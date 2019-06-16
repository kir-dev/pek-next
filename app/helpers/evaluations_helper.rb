module EvaluationsHelper
  def single_detail(point_details, user, principle)
    point_details.find do |pd|
      pd.point_request.user_id == user.id && pd.principle_id == principle.id
    end
  end

  def sum_work_details(point_details, user)
    [sum_details(point_details, user, Principle::WORK), 30].min
  end

  def sum_responsibility_details(point_details, user)
    [sum_details(point_details, user, Principle::RESPONSIBILITY), 50].min
  end

  def sum_all_details(point_details, user)
    sum = sum_responsibility_details(point_details, user) + sum_work_details(point_details, user)
    sum_clipped = [sum, 50].min
    return 5 if [3, 4].include? sum_clipped
    return 0 if [1, 2].include? sum_clipped

    sum
  end

  def entry_request(evaluation, user)
    evaluation.entry_requests.find { |er| er.user_id == user.id }&.entry_type ||
      EntryRequest::DEFAULT_TYPE
  end

  def sum_principle_details(point_details, principle)
    point_details.select { |pd| pd.principle_id == principle.id }.sum(&:point)
  end

  private

  def sum_details(point_details, user, principle_type)
    point_details.select do |pd|
      pd.point_request.user_id == user.id && pd.principle.type == principle_type
    end.sum(&:point)
  end
end
