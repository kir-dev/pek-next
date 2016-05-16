class GroupsController < ApplicationController
  before_action :require_login

  def index
    @groups = Group.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @group = Group.find(params[:group_id])
    @memberships = GrpMembership.where(grp_id: @group.id, membership_end: nil)
    @members = []
    @memberships.each do |m|
      @members.push(User.find(m.usr_id))
    end
    @posts = []
    @memberships.each_with_index do |m, index|
      posts = Poszt.where(grp_member_id: m.id)
      @posts.push([])
      posts.each do |p|
        @posts[index].push(Poszttipus.find(p.pttip_id))
      end
    end
    @is_member = is_member(@group.id, @user.id)
    @is_leader = @is_member && Poszt.where(grp_member_id: GrpMembership.where(grp_id: @group.id, usr_id: @user.id)[0].id, pttip_id: 3).length > 0
  end

  def apply
    @group = Group.find(params[:group_id])
    if !@group.users_can_apply || is_member(@group.id, @user.id)
      raise #TODO: render unathorized exception page
    end
    membership = GrpMembership.create(grp_id: @group.id, usr_id: @user.id)
    Poszt.create(grp_member_id: membership.id, pttip_id: 6)
    redirect_to :back
  end

  def is_member(grp_id, usr_id)
    return GrpMembership.where(grp_id: grp_id, usr_id: usr_id).length > 0
  end
end
