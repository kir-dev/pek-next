class GroupsController < ApplicationController
  #before_action :require_login

  def index
    @groups = Group.paginate(:page => params[:page], :per_page => 20)
  end

  def show

    @group = Group.find(params[:group_id])
  end
end
