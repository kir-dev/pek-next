class CreateJudgement
  attr_reader :params, :evaluation

  def initialize(params, evaluation)
    @params = params
    @evaluation = evaluation
  end

  def call
    return false unless changed?
    message = create_message
    EvaluationMessage.create(sent_at: DateTime.now, message: message, from_system: true,
      semester: evaluation.semester, sender_user: nil, group: evaluation.group)
    evaluation.update(params)
  end

  def create_message
    point_request_change = request_change_message(evaluation.point_request_status, params[:point_request_status])
    entry_request_change = request_change_message(evaluation.entry_request_status, params[:entry_request_status])
    explanation = params[:explanation] || 'nincs megadva'
    "Pontkérelem státusza: #{point_request_change}, belépőkérelem státusza: #{entry_request_change}, indoklás: #{explanation}"
  end

  def request_change_message(old_request, new_request)
    return 'nem változott' if old_request == new_request
    "#{old_request} -> #{new_request}"
  end

  def changed?
    evaluation.point_request_status != params[:point_request_status] ||
    evaluation.entry_request_status != params[:entry_request_status]
  end

end
