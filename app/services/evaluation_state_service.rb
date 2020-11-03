class EvaluationStateService
  include AASM

  attr_reader :evaluation

  def initialize(evaluation)
    @evaluation = evaluation
    aasm.current_state = evaluation.point_request_status
  end

  aasm do
    state :NON_EXISTENT, initial: true
    state :ACCEPTED
    state :NOT_YET_ASSESSED
    state :REJECTED

    after_all_transitions :update_evaluation

    event :accept do
      transitions from: :NOT_YET_ASSESSED, to: :ACCEPTED, guards: :can_accept?
    end

    event :reject do
      transitions from: :NOT_YET_ASSESSED, to: :REJECTED, guards: :can_reject?
    end

    event :submit do
      transitions from: :NON_EXISTENT, to: :NOT_YET_ASSESSED, guards: :can_submit?
    end
  end

  private

  def update_evaluation
    evaluation.update!(point_request_status: Evaluation:: aasm.to_state)
  end

  def can_reject?
    !off_season? || leader_of_the_resort?
  end

  def can_accept?
    !off_season?
  end

  def can_submit?
    !off_season?
  end

  def user
    current_user
  end

  def leader_of_the_group?
    user.leader_of?(evaluation.group)
  end

  def leader_of_the_resort?
    user.leader_of?(evaluation.group.parent)
  end

  def pek_admin?
    user.roles.pek_admin?
  end

  def off_season?
    SystemAttribute.offseason?
  end

  def application_season?
    SystemAttribute.application_season?
  end

  def evaluation_season?
    SystemAttribute.evaluation_season?
  end
end
