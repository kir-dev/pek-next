class PostsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    authorize @group, :manage_posts?
    @membership = Membership.find(params[:membership_id])
  end

  def group_posts
    @group = Group.includes(:post_types, :memberships).find(params[:group_id])
    authorize @group, :manage_posts?

    @post_type_ids = @group.post_types.map(&:id)
                           .reject { |post_type_id| post_type_id.eql? PostType::LEADER_POST_ID }
    @group_post_types = @group.post_types.reduce({}) do |hash, post_type|
      hash.merge({ post_type.id => post_type })
    end
    @memberships = @group.memberships.active.includes(:posts, :user)
                         .sort { |a, b| hu_compare(a.user.full_name, b.user.full_name) }
  end

  def create
    group = Group.find(params[:group_id])
    membership = Membership.find(params[:membership_id])
    post_type_id = params[:post_type_id].to_i
    authorize Post.new(membership: membership, post_type_id: post_type_id)

    new_post = CreatePost.call(group, membership, post_type_id)
    respond_to do |format|
      format.html do
        return redirect_to group_path(group) if new_post.leader?

        redirect_back fallback_location: group_path(group)
      end
      format.json { render json: { post_id: new_post.id } }
    end
  end

  def destroy
    post_id = params[:id]
    group_url = group_path(params[:group_id])
    authorize Post.find(post_id)

    destroyed = DestroyPost.call(post_id)
    respond_to do |format|
      format.html do
        return redirect_back fallback_location: group_url if destroyed

        redirect_back fallback_location: group_url, alert: t(:no_leader_error)
      end
      format.json { return render plain: 'ok', status: :ok }
    end
  end
end
