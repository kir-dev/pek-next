class PostTypesController < ApplicationController
  before_action :require_login

  def create
    require_leader(params[:r])
    PostType.create(params.require(:post_type).permit(:name))
    redirect_to :back
  end

end
