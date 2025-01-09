class SubGroupsController < ApplicationController
  before_action :set_sub_group, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :require_sssl
  before_action :create_evaluation_if_not_present, only: [:index]
  # GET /sub_groups
  def index
    @sub_group = SubGroup.new(group: current_group)
    authorize @sub_group
    @policy = policy(@sub_group)
    @sub_groups = SubGroup.where(group: current_group)
    @sub_group_memberships = SubGroupMembership.where(membership: current_membership)
    @current_user_subgroup_ids = @sub_group_memberships.map(&:sub_group_id)
  end

  # GET /sub_groups/1
  def show
    authorize @sub_group
    @policy = policy(@sub_group)
    @sub_group_memberships = @sub_group.sub_group_memberships.includes(membership: :user)
    @sub_group_principle_policy = SubGroupPrinciplePolicy.new(current_user, @sub_group)
    @sub_group_evaluation_policy = SubGroupEvaluationPolicy.new(current_user, @sub_group)
  end

  # GET /sub_groups/new
  def new
    authorize SubGroup.new(group: current_group)

    @sub_group = SubGroup.new
  end

  # GET /sub_groups/1/edit
  def edit
    authorize SubGroup.new(group: current_group)
  end

  # POST /sub_groups
  def create
    @sub_group = SubGroup.new(sub_group_params)
    @sub_group.group_id = params[:group_id]
    authorize @sub_group

    if @sub_group.save
      redirect_to group_sub_group_path(current_group, @sub_group)
    else
      render :new
    end
  end

  # PATCH/PUT /sub_groups/1
  def update
    authorize @sub_group
    if @sub_group.update(sub_group_params)
      redirect_to group_sub_group_path(current_group, @sub_group)
    else
      render :edit
    end
  end

  # DELETE /sub_groups/1
  def destroy
    authorize @sub_group
    ActiveRecord::Base.transaction do
      @sub_group.sub_group_memberships.destroy_all
      @sub_group.principles.update_all(sub_group_id: nil)
      @sub_group.destroy
    end
    redirect_to group_sub_groups_path(current_group)
  end

  def join
    authorize @sub_group
    SubGroupMembership.create!(membership: current_membership, sub_group: @sub_group)

    redirect_to group_sub_groups_path(current_group)
  end

  def leave
    authorize @sub_group
    sub_group_membership = SubGroupMembership.find_by(
      membership: current_membership,
      sub_group: @sub_group)
    sub_group_membership.destroy!

    redirect_to group_sub_groups_path(current_group)
  end

  def set_admin
    @sub_group_membership = SubGroupMembership.find(params[:sub_group_membership_id])
    authorize @sub_group_membership.sub_group

    @sub_group_membership.update!(admin: params[:admin])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sub_group
    @sub_group = SubGroup.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sub_group_params
    params.require(:sub_group).permit(:name)
  end

  def current_membership
    @current_membership ||= current_user.membership_for(current_group)
  end

  def create_evaluation_if_not_present
    evaluation = Evaluation.find_by(group_id: current_group.id, semester: current_semester)
    return if evaluation.present?

    evaluation = Evaluation.new(group_id: current_group.id,
                                creator_user_id: current_user.id,
                                semester: current_semester)
    evaluation.set_default_values
    evaluation.save!
  end
end
