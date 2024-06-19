class SubGroupMembershipsController < ApplicationController
  before_action :set_sub_group_membership, only: :destroy
  def destroy
    authorize @sub_group_membership
    @sub_group_membership.destroy!
    @sub_group_membership_row_id = params[:sub_group_membership_row_id]
  end

  private

  def set_sub_group_membership
    @sub_group_membership = SubGroupMembership.find(params[:id])
  end
end
