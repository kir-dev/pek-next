class PostTypesController < ApplicationController
  before_action :require_leader

  def create
    post_type_params = params.require(:post_type).permit(:name, :group_id)
    post_type = PostType.create(post_type_params)

    group_url = group_path(params[:group_id])
    return redirect_back fallback_location: group_url unless post_type.errors.any?

    redirect_back fallback_location: group_url, alert: post_type.errors.to_a.first
  end
end
