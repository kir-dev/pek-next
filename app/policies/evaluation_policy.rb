class EvaluationPolicy < ApplicationPolicy
  def show?
    (leader_of_the_group? || evaluation_helper_of_the_group? || leader_of_the_resort? ||
      pek_admin? || leader_in_the_resort?) && !off_season?
  end

  alias current? show?
  alias table? show?

  def edit?
    submit_point_request?
  end

  alias index? edit?
  alias update? edit?
  alias create? edit?
  alias destroy? edit?

  def update_point_request?
    !off_season? &&
      point_request_status != Evaluation::ACCEPTED && (
      ((leader_of_the_group? || evaluation_helper_of_the_group? || pek_admin?) &&
        point_request_status != Evaluation::NOT_YET_ASSESSED) ||
        (leader_of_the_resort? && evaluation_season?)
    )
  end

  def submit_point_request?
    !off_season? &&
      ![Evaluation::NOT_YET_ASSESSED, Evaluation::ACCEPTED].include?(point_request_status) &&
      (leader_of_the_group? || pek_admin?)
  end

  def cancel_point_request?
    application_season? &&
      point_request_status == Evaluation::NOT_YET_ASSESSED &&
      (leader_of_the_group? || pek_admin?)
  end

  def update_entry_request?
    !off_season? &&
      entry_request_status != Evaluation::ACCEPTED && (
      ((leader_of_the_group? || evaluation_helper_of_the_group? || pek_admin?) &&
        entry_request_status != Evaluation::NOT_YET_ASSESSED) ||
        (leader_of_the_resort? && evaluation_season?)
    )
  end

  def submit_entry_request?
    !off_season? &&
      ![Evaluation::NOT_YET_ASSESSED, Evaluation::ACCEPTED].include?(entry_request_status) &&
      (leader_of_the_group? || pek_admin?)
  end

  def cancel_entry_request?
    application_season? &&
      entry_request_status == Evaluation::NOT_YET_ASSESSED &&
      (leader_of_the_group? || pek_admin?)
  end

  private

  def leader_of_the_group?
    user.leader_of?(evaluation.group)
  end

  def evaluation_helper_of_the_group?
    user.evaluation_helper_of?(evaluation.group)
  end

  def leader_of_the_resort?
    user.leader_of?(evaluation.group.parent)
  end

  def leader_in_the_resort?
    evaluation.group.parent&.children&.any? { |group| user.leader_of?(group) }
  end

  def point_request_status
    evaluation.point_request_status
  end

  def entry_request_status
    evaluation.entry_request_status
  end

  def evaluation
    record
  end
end
