class SvieController < ApplicationController
  before_action :require_login
  before_action :require_privileges_of_rvt, only: [:index, :approve]

  def new
    redirect_to svie_edit_path unless current_user.primary_membership
  end

  def create
    update_params = params.permit(:home_address, :mother_name, :svie_member_type)
    update_params[:svie_state] = :ELFOGADASALATT
    current_user.update(update_params)
    redirect_to svie_successful_path
  end

  def edit
    @svie_memberships = current_user.memberships.select { |m| m.group.issvie && !m.newbie? }
    redirect_to :back, alert: t(:svie_group_needed) if @svie_memberships.empty?
  end

  def update
    current_user.update(svie_primary_membership: params[:svie][:primary_membership])
    current_user.update(delegated: false)
    if current_user.not_member_of_svie?
      redirect_to new_svie_path
    else
      redirect_to profiles_me_path, notice: t(:edit_successful)
    end
  end

  def index
    @not_svie_members = User.where(svie_state: [:FELDOLGOZASALATT, :ELFOGADASALATT])
  end

  def approve
    user = User.find(params[:id])
    user.update(svie_state: :ELFOGADVA)
    redirect_to :back, notice: user.full_name + ' ' + t(:accept_application)
  end

  def successful_application
  end

  def application_pdf
    send_data GenerateMembershipPdf.call(current_user), filename: 'szerzodes.pdf', type: 'application/pdf'
  end

  def destroy
    current_user.remove_svie_membership!
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end
end
