class PostsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    authorize @group, :manage_posts?
    @membership = Membership.find(params[:membership_id])
  end

  def create
    group = Group.find(params[:group_id])
    membership = Membership.find(params[:membership_id])
    post_type_id = params[:post_type_id].to_i
    authorize Post.new(membership: membership, post_type_id: post_type_id)

    new_post = CreatePost.call(group, membership, post_type_id)
    return redirect_to group_path(group) if new_post.leader?

    redirect_back fallback_location: group_path(group)
  end

  def destroy
    post_id = params[:id]
    group_url = group_path(params[:group_id])
    authorize Post.find(post_id)
    return redirect_back fallback_location: group_url if DestroyPost.call(post_id)

    redirect_back fallback_location: group_url, alert: t(:no_leader_error)
  end
end
