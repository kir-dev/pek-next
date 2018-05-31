class DetailedPointHistory
  def initialize(point_request)
    @point_request = point_request
    @evaluation = point_request.evaluation
    @group = @evaluation.group
    @entry_request = @evaluation.entry_requests.find_by user_id: point_request.usr_id
  end

  def group_name
    @group.grp_name
  end

  def group_id
    @group.id
  end

  def semester
    Semester.new(@evaluation.date).to_readable
  end

  def point
    @point_request.point
  end

  def entry_card_type
    @entry_request ? @entry_request.entry_type : EntryRequest::DEFAULT_TYPE
  end

  def entry_card_explanation
    @entry_request ? @entry_request.justification : ''
  end
end
