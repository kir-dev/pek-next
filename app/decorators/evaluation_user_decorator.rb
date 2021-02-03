class EvaluationUserDecorator < UserDecorator
  attr_accessor :point_request, :point_details, :entry_request

  def point_request
    @point_request ||= user.point_requests.find { |pr| pr.evaluation_id == evaluation.id }
  end

  def point_details
    @point_details ||= point_request&.point_details
  end

  def entry_request
    @entry_request ||= user.entry_requests.find { |er| er.evaluation_id == evaluation.id }
  end

  def single_detail(principle)
    return nil if point_details.nil?

    point_details.find do |pd|
      pd.principle_id == principle.id
    end
  end

  def sum_work_point
    @sum_work_point ||= [sum_details(point_details, Principle::WORK), 30].min
  end

  def sum_responsibility_point
    @sum_responsibility_point ||= [sum_details(point_details, Principle::RESPONSIBILITY), 20].min
  end

  def sum_all_point
    @sum_all_point ||= sum_all_details
  end

  def sum_all_details
    sum = sum_responsibility_point + sum_work_point
    return 5 if [3, 4].include? sum
    return 0 if [1, 2].include? sum

    [sum, 50].min
  end

  def sum_principle_details(principle)
    return 0 if point_details.nil?

    point_details.select { |pd| pd.principle_id == principle.id }.sum(&:point)
  end

  private

  def sum_details(point_details, principle_type)
    return 0 if point_details.nil?

    point_details.select do |pd|
      pd.principle.type == principle_type
    end.sum(&:point)
  end

  def evaluation
    context[:evaluation]
  end
end
