class PostTypesController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def create
    post_type_params = params.require(:post_type).permit(:name, :group_id)
    post_type = PostType.create(post_type_params)
    return redirect_back unless post_type.errors.any?
    redirect_back alert: post_type.errors.to_a.first
  end

end
