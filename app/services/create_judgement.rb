class CreateJudgement

  def self.call(evaluation, params)
    return false unless self.changed?(evaluation, params)
    message = self.create_message(evaluation, params)
    EvaluationMessage.create(sent_at: DateTime.now, message: message, from_system: true,
      semester: evaluation.semester, sender_user: nil, group: evaluation.group)
    evaluation.update(params)
  end

  def self.create_message(evaluation, params)
    old_point_request_status = evaluation.point_request_status
    new_point_request_status = params[:point_request_status]
    if old_point_request_status == new_point_request_status
      point_request_change = 'nem változott'
    else
      point_request_change = "#{old_point_request_status} -> #{new_point_request_status}"
    end

    old_entry_request_status = evaluation.entry_request_status
    new_entry_request_status = params[:entry_request_status]
    if old_entry_request_status == new_entry_request_status
      entry_request_change = 'nem változott'
    else
      entry_request_change = "#{old_entry_request_status} -> #{new_entry_request_status}"
    end

    explanation = params[:explanation] || 'nincs megadva'
    "Pontkérelem státusza: #{point_request_change}, belépőkérelem státusza: #{entry_request_change}, indoklás: #{explanation}"
  end

  def self.changed?(evaluation, params)
    evaluation.point_request_status != params[:point_request_status] ||
    evaluation.entry_request_status != params[:entry_request_status]
  end

end
