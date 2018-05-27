class PostsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def index
    @group = Group.find(params[:group_id])
    @membership = Membership.find(params[:membership_id])
  end

  def create
    group = Group.find(params[:group_id])
    membership = Membership.find(params[:membership_id])
    post_type_id = params[:post_type_id].to_i

    new_post = CreatePost.call(group, membership, post_type_id)
    if new_post.leader?
      return redirect_to group_path(group)
    end
    redirect_back
  end

  def destroy
    post_id = params[:id]
    return redirect_back if DestroyPost.call(post_id)
    redirect_back alert: t(:no_leader_error)
  end

end
