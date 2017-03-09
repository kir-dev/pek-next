class GroupsController < ApplicationController
  before_action :require_login
  before_action :before_action_init

  def before_action_init
    @group = Group.find(params[:group_id])
    @is_member = is_member(@group.id, current_user.id)
    @is_leader = is_leader(@group.id, current_user.id)
  end

  def index
    @groups = Group.paginate(:page => params[:page], :per_page => 20)
  end

  def show
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
  end

  def apply
    if !@group.users_can_apply || is_member(@group.id, current_user.id)
      raise #TODO: render unathorized exception page
    end
    membership = GrpMembership.create(grp_id: @group.id, usr_id: current_user.id)
    Poszt.create(grp_member_id: membership.id, pttip_id: 6)
    redirect_to :back
  end

  def inactivate
    if !is_leader(params[:group_id], current_user.id)
      raise
    end
    params.each do |p|
      if p[0].include? "check-"
        inac_id = p[0].sub "check-", ""
        GrpMembership.update(inac_id, membership_end: Time.now)
      end
    end
    redirect_to :back
  end

  def is_member(grp_id, usr_id)
    return GrpMembership.where(grp_id: grp_id, usr_id: usr_id).length > 0
  end

  def is_leader(grp_id, usr_id)
    return is_member(grp_id, usr_id) && Poszt.where(grp_member_id: GrpMembership.where(grp_id: grp_id, usr_id: usr_id)[0].id, pttip_id: 3).length > 0
  end

  def change_pos
    #raise
    if @is_leader
      raise
    end
  end
end
