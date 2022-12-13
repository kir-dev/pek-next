class SubGroupPrinciplesController < ApplicationController
  before_action :set_principle, only: %i[update destroy]
  before_action :validate_correct_evaluation, only: %i[update destroy]
  # before_action :authorize_evaluation, except: [:index]
  before_action :set_sub_group, only: [:index, :create, :update]
  before_action :require_sssl

  def index
    authorize Principle.new(sub_group: @sub_group), policy_class: SubGroupPrinciplePolicy
    @evaluation = current_evaluation
    @principles = @evaluation.principles.where(sub_group: @sub_group).order(:type, :id)
    @can_edit = true
  end

  def update
    @principle.attributes = principle_params
    authorize @principle, policy_class: SubGroupPrinciplePolicy
    @principle.save!
    render 'principles/update'
  end

  def create
    @principle = Principle.new(principle_params)

    @evaluation = current_evaluation
    @principle.evaluation = @evaluation
    @principle.sub_group = @sub_group

    authorize @principle, policy_class: SubGroupPrinciplePolicy
    # Todo add error handling
    @principle.save
    @can_edit = true
    render 'principles/create'
  end

  def destroy
    authorize @principle, policy_class: SubGroupPrinciplePolicy
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
