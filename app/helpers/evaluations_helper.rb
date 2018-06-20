module EvaluationsHelper
  def single_detail(point_details, user, principle)
    point_detail = point_details.find { |pd| pd.point_request.user == user && pd.principle_id == principle.id }&.point
  end

  def sum_work_details(point_details, user)
    [sum_details(point_details, user, Principle::WORK), 30].min
  end

  def sum_responsibility_details(point_details, user)
    [sum_details(point_details, user, Principle::RESPONSIBILITY), 20].min
  end

  def sum_all_details(point_details, user)
    sum_responsibility_details(point_details, user) + sum_work_details(point_details, user)
  end

  def entry_request(evaluation, user)
    evaluation.entry_requests.find { |er| er.user == user }&.entry_type || EntryRequest::DEFAULT_TYPE
  end

  private
    def sum_details(point_details, user, principle_type)
      point_details.select { |pd| pd.point_request.user == user && pd.principle.type == principle_type }
      .sum { |pd| pd.point }
    end
end
