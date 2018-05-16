class PostTypesController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def create
    PostType.create(params.require(:post_type).permit(:name, :group_id))
    redirect_to :back
  end

end
