class MessagesController < ApplicationController
  before_action :require_login
  before_action :require_leader, except: :create
  before_action :require_leader_or_rvt_member, only: :create
  before_action :require_application_or_evaluation_season

  def index
    @semester = SystemAttribute.semester.to_s
    @evaluation_messages =
      EvaluationMessage.where(group: @group, semester: @semester)
                       .order(sent_at: :desc).page(params[:page]).decorate
  end

  def all
    @evaluation_messages =
      EvaluationMessage.where(group: @group)
                       .order(sent_at: :desc).page(params[:page]).decorate
    render :index
  end

  def create
    semester = SystemAttribute.semester.to_s
    EvaluationMessage.create(message: params[:message], group: current_group,
                             sender_user: current_user, sent_at: DateTime.now,
                             semester: semester)
    redirect_back fallback_location: group_messages_path(current_group)
  end
end
