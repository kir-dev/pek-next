class PostsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def index
    @group = Group.find(params[:group_id])
    @membership = Membership.find(params[:membership_id])
  end

end
