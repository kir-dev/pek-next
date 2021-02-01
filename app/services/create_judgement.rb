class CreateJudgement
  class UserCantMakeTheRequestedUpdates < StandardError; end
  class NoChangeHaveBeenMade < StandardError; end

  attr_reader :params, :evaluation, :judgement_policy

  def initialize(params, evaluation, user)
    @params            = params
    @evaluation        = evaluation
    @judgement_policy = JudgementPolicy.new(user, evaluation)
  end

  def call
    raise NoChangeHaveBeenMade unless changed?
    raise UserCantMakeTheRequestedUpdates unless can_be_updated_by_user?

    message = create_message
    EvaluationMessage.create(sent_at:  Time.now, message: message, from_system: true,
                             semester: evaluation.semester, sender_user: nil,
                             group:    evaluation.group)
    evaluation.update(params)
  end

  private

  def create_message
    point_request_change =
      request_change_message(evaluation.point_request_status, params[:point_request_status])
    entry_request_change =
      request_change_message(evaluation.entry_request_status, params[:entry_request_status])
    explanation          = params[:explanation] || 'nincs megadva'

    "Pontkérelem státusza: #{point_request_change}, belépőkérelem státusza: \
    #{entry_request_change}, indoklás: #{explanation}"
  end

  def request_change_message(old_request, new_request)
    return 'nem változott' if old_request == new_request

    "#{old_request} -> #{new_request}"
  end

  def changed?
    point_request_status_changed? || entry_request_status_changed?
  end

  def can_be_updated_by_user?
    return false unless check_access_to(:point_request)
    return false unless check_access_to(:entry_request)

    true
  end

  def check_access_to(request_type)
    request_type = request_type.to_s

    return true unless send(request_type + '_status_changed?')
    if params[(request_type + '_status').to_sym] == Evaluation::ACCEPTED
      return judgement_policy.accept?
    end
    return true if judgement_policy.send('update_' + request_type + '_status?')

    false
  end

  def point_request_status_changed?
    evaluation.point_request_status != params[:point_request_status]
  end

  def entry_request_status_changed?
    evaluation.entry_request_status != params[:entry_request_status]
  end
end
