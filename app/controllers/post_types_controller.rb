class PostTypesController < ApplicationController
  before_action :require_leader
  before_action :set_group, only: %i[index destroy]

  def create
    post_type_params = params.require(:post_type).permit(:name, :group_id)
    post_type        = PostType.create(post_type_params)

    group_url = group_path(params[:group_id])
    return redirect_back fallback_location: group_url unless post_type.errors.any?

    redirect_back fallback_location: group_url, alert: post_type.errors.to_a.first
  end

  def index
    @post_types = PostType.where(group_id: @group.id).without_common.with_users
  end

  def destroy
    post_type = PostType.find(params[:id])

    if DestroyPostType.call(@group, post_type)
      redirect_back fallback_location: group_url, notice: 'Poszt törlése sikeres volt'
    else
      redirect_back fallback_location: group_url, alert: 'Alapvető posztokat nem lehet törölni'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
