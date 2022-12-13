class SubGroupsController < ApplicationController
  before_action :set_sub_group, only: [:show, :edit, :update, :destroy, :join, :leave]

  # GET /sub_groups
  def index
    @sub_groups = SubGroup.where(group: current_group)
    sub_group_memberships = SubGroupMembership.where(membership: current_membership)
    @current_user_subgroup_ids = sub_group_memberships.map(&:sub_group_id)
  end

  # GET /sub_groups/1
  def show
    @sub_group_memberships = @sub_group.sub_group_memberships.includes(membership: :user)
  end

  # GET /sub_groups/new
  def new
    @sub_group = SubGroup.new
  end

  # GET /sub_groups/1/edit
  def edit
  end

  # POST /sub_groups
  def create
    @sub_group = SubGroup.new(sub_group_params)
    @sub_group.group_id = params[:group_id]

    if @sub_group.save
      redirect_to group_sub_group_path(current_group, @sub_group),
                  notice: 'Sub group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sub_groups/1
  def update
    if @sub_group.update(sub_group_params)
      redirect_to group_sub_group_path(current_group, @sub_group),
                  notice: 'Sub group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sub_groups/1
  def destroy
    ActiveRecord::Base.transaction do
      @sub_group.sub_group_memberships.destroy_all
      @sub_group.principles.update_all(sub_group_id: nil)
      @sub_group.destroy
    end
    redirect_to group_sub_groups_path(current_group), notice: 'Sub group was successfully destroyed.'
  end

  def join
    SubGroupMembership.create!(membership: current_membership, sub_group: @sub_group)

    redirect_to group_sub_groups_path(current_group)
  end

  def leave
    sub_group_membership = SubGroupMembership.find_by(
      membership: current_membership,
      sub_group: @sub_group)
    sub_group_membership.destroy!

    redirect_to group_sub_groups_path(current_group)
  end

  def set_admin
    @sub_group_membership = SubGroupMembership.find(params[:sub_group_membership_id])
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
end
