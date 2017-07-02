class GroupsController < ApplicationController
  before_action :require_login
  before_action :init, only: [:show]

  def init
    @group = Group.find(params[:id])
    @own_membership = current_user.membership_for(@group)
  end

  def index
    @groups = Group.order(:name).page(params[:page]).per(params[:per])
  end

  def show
  end

  def is_leader
    @own_membership && @own_membership.is_leader
  end
  helper_method :is_leader

end
