class PostTypesController < ApplicationController
  before_action :require_leader
  before_action :set_group, only: %i[index destroy]

  def create
    post_type_params = params.require(:post_type).permit(:name, :group_id)
    post_type = PostType.create(post_type_params)

    group_url = group_path(params[:group_id])
    return redirect_back fallback_location: group_url unless post_type.errors.any?

    redirect_back fallback_location: group_url, alert: post_type.errors.to_a.first
  end

  def index
    @post_types = PostType.where(group_id: @group.id).without_common.with_users
  end

  def destroy
    post_type = PostType.find(params[:id])
    can_be_deleted =
      post_type.posts.empty? &&
      !PostType::COMMON_TYPES.include?(post_type.id) &&
      post_type.group.id == @group.id

    return redirect_back fallback_location: group_url, alert: 'A poszt nem törölhető, mert használatban van!' unless can_be_deleted
    post_type.destroy
    redirect_back fallback_location: group_url
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
