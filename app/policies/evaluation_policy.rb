class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  EDIT = %i[edit update
            submit_entry_request cancel_entry_request
            submit_point_request cancel_point_request].freeze
  READ = %i[current show table].freeze

  EDIT.each do |m|
    m = m.to_s.concat('?').to_sym
    define_method(m) { group_leader }
  end

  READ.each do |m|
    m = m.to_s.concat('?').to_sym
    define_method(m) { group_leader || resort_laeder }
  end

  private

  def resort_laeder
    user.leader_of?(evaluation.group.parent)
  end

  def group_leader
    user.leader_of?(evaluation.group)
  end

  def evaluation
    record
  end
end
