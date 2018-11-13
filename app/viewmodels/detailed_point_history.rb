class DetailedPointHistory
  attr_reader :group, :user, :point_request, :entry_request, :evaluation

  def initialize(point_request)
    @point_request = point_request
    @evaluation = point_request.evaluation
    @group = evaluation.group
    @user = point_request.user
    @entry_request = evaluation.entry_requests.find_by user_id: point_request.user_id
  end

  def group_name
    group.name
  end

  def group_id
    group.id
  end

  def user_screen_name
    user.screen_name
  end

  def user_name
    user.decorate.compact_name
  end

  def semester
    evaluation.date_as_semester
  end

  def point
    point_request.point
  end

  def entry_card_type
    return EntryRequest::DEFAULT_TYPE unless entry_request&.accepted?
    entry_request.entry_type
  end

  def entry_card_explanation
    return '' unless entry_request&.accepted?
    entry_request.justification
  end
end
