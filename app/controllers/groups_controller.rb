class GroupsController < ApplicationController
  before_action :require_login
  before_action :initialize, only: [:show]

  def initialize
    @group = Group.find(params[:id])
    @own_membership = current_user.memberships.find { |m| m.group == @group }
  end

  def index
    @groups = Group.order(:name).page(params[:page]).per(20)
  end

  def show
  end
end
