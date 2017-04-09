class GroupsController < ApplicationController
  before_action :require_login
  before_action :before_action_init, only: [:show]

  def before_action_init
    @group = Group.find(params[:id])
    @is_member = MembershipController.new.is_member(@group.id, current_user.id)
    @is_leader = MembershipController.new.is_leader(@group.id, current_user.id)
  end

  def index
    @groups = Group.order(:name).page(params[:page]).per(20)
  end

  def show
  end
end
