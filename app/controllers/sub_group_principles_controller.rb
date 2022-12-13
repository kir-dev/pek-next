class SubGroupPrinciplesController < ApplicationController
  before_action :set_principle, only: %i[update destroy]
  before_action :validate_correct_evaluation, only: %i[update destroy]
  # before_action :authorize_evaluation, except: [:index]
  before_action :set_sub_group, only: [:index, :create, :update]

  def index
    @evaluation = current_evaluation
    authorize @evaluation, :show?

    @principles = @evaluation.principles.where(sub_group: @sub_group).order(:type, :id)
    @can_edit = true
  end

  def update
    @principle.update(principle_params)

    render 'principles/update'
  end

  def create
    @principle = Principle.new(principle_params)
    @evaluation = current_evaluation
    @principle.evaluation = @evaluation
    @principle.sub_group = @sub_group
    @principle.save

    render 'principles/create'
  end

  def destroy
    @principle.destroy

    render 'principles/destroy'
  end

  private

  def set_principle
    @principle = Principle.find(params[:id])
  end

  def validate_correct_evaluation
    render forbidden_page unless current_evaluation == @principle.evaluation
  end

  def principle_params
    params.require(:principle).permit(:type, :name, :max_per_member, :description)
  end

  def current_evaluation
    current_group.current_evaluation
  end

  def set_sub_group
    @sub_group = SubGroup.find(params[:sub_group_id])
  end
end
