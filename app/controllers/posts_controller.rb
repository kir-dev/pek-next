class PostsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def index
    @group = Group.find(params[:group_id])
    @membership = Membership.find(params[:membership_id])
  end

  def create
    @membership = Membership.find(params[:membership_id])
    Post.create(grp_member_id: @membership.id, post_type_id: params[:post_type_id])
    redirect_to :back
  end

  def destroy
    Post.delete(params[:id])
    redirect_to :back
  end

end
