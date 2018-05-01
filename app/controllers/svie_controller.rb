class SvieController < ApplicationController
  before_action :require_login
  before_action :require_privileges_of_rvt, only: [:index, :approve]

  def new
    redirect_to svie_edit_path unless current_user.primary_membership
  end

  def create
    params.permit(:svie_member_type)
    update_params = params.permit(:home_address, :mother_name)
    current_user.update(update_params)
    current_user.svie.create_request(params[:svie_member_type])
    redirect_to svie_successful_path
  end

  def edit
    @svie_memberships = current_user.memberships.select { |m| m.group.issvie && m.active? }
    redirect_to :back, alert: t(:svie_group_needed) if @svie_memberships.empty?
  end

  def update
    current_user.update(svie_primary_membership: params[:svie][:primary_membership])
    current_user.update(delegated: false)
    if current_user.svie.member?
      redirect_to profiles_me_path, notice: t(:edit_successful)
    else
      redirect_to new_svie_path
    end
  end

  def index
    @post_requests = SviePostRequest.all
  end

  def approve
    svie_post_request = SviePostRequest.find(params[:id])
    user = User.find(svie_post_request.usr_id)
    user.update(svie_member_type: svie_post_request.member_type)
    svie_post_request.destroy
    redirect_to :back, notice: user.full_name + ' ' + t(:accept_application)
  end

  def reject
    svie_post_request = SviePostRequest.destroy(params[:id])
    user = User.find(svie_post_request.usr_id)
    redirect_to :back, notice: user.full_name + ' ' + t(:abort_application)
  end

  def successful_application
  end

  def application_pdf
    send_data GenerateMembershipPdf.call(current_user), filename: 'szerzodes.pdf', type: 'application/pdf'
  end

  def destroy
    current_user.svie.create_request('NEMTAG')
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end

  def outside
    current_user.svie.create_request('KULSOSTAG')
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end

  def inside
    current_user.svie.create_request('BELSOSTAG')
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end
end
