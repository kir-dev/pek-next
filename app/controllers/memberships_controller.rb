class MembershipsController < ApplicationController
  before_action :require_leader, only: %i[inactivate destroy reactivate archive accept unarchive]

  def create
    @group = Group.find(params[:group_id])
    if @group.user_can_join?(current_user)
      CreateMembership.call(@group, current_user)
      redirect_back(fallback_location: group_path(@group))
    else
      handle_unarchivation_request
    end
  end

  def archive
    membership = Membership.find(params[:membership_id])
    return forbidden_page if membership.archived?

    membership.archive!
    membership.user.svie.try_inactivate!
  end

  def unarchive
    membership = Membership.find(params[:membership_id])
    return forbidden_page if !membership.archived? || membership.inactive?

    membership.unarchive!
  end

  def inactivate
    membership = Membership.find(params[:membership_id])
    membership.inactivate!
    membership.user.svie.try_inactivate!
  end

  def reactivate
    Membership.find(params[:membership_id]).reactivate!
  end

  def accept
    Membership.find(params[:membership_id]).accept!
  end

  private

  def handle_unarchivation_request
    membership = @group.member?(current_user)
    if membership && membership.can_request_unarchivation?
      request_unarchivation(membership)
      redirect_back(fallback_location: group_path(@group))
    else
      forbidden_page
    end
  end

  def request_unarchivation(membership)
    CreatePost.call(membership.group, membership, PostType::DEFAULT_POST_ID)
    membership.notify(:users, key: 'membership.create', notifier: current_user)
  end
end
