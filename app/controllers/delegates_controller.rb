class DelegatesController < ApplicationController
  before_action :require_leader, only: %i[show create destroy]
  before_action :require_svie_admin, only: %i[index export]

  def index
    @delegates = User.includes([{ primary_membership: [:group] }])
                     .where(delegated: true).order(:lastname)
                     .select { |user| user.primary_membership.group.issvie }
  end

  def show
    # There are 68 active svie members without a primary group
    @eligible_members =
      @group.members.includes([{ primary_membership: [{ posts: [:post_type] }] }])
            .where(svie_member_type: SvieUser::INSIDE_MEMBER).order(:lastname)
            .select do |user|
              group_id = params[:group_id].to_i
              user.eliglibe_member?(group_id)
            end
  end

  def create
    unless @group.can_delegate_more
      return redirect_to group_delegates_path(params[:group_id]), alert: t(:too_many_delegates)
    end

    User.find(params[:member_id]).update(delegated: true)
    redirect_to group_delegates_path(params[:group_id])
  end

  def destroy
    User.find(params[:member_id]).update(delegated: false)
    redirect_to group_delegates_path(params[:group_id])
  end
end
