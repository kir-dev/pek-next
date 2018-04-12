class EvaluationsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:new, :create]

  def new
    @evaluation = Evaluation.find_by({ group_id: @group.id, semester: SystemAttribute.semester.to_s })
    unless @evaluation
      @evaluation = Evaluation.create({
        group_id: current_group.id,
        creator_user_id: current_user.id,
        semester: SystemAttribute.semester.to_s
        })
    end
  end

  def create
  end

end
