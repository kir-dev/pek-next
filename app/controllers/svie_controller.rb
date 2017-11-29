class SvieController < ApplicationController
  before_action :require_login

  def new
    redirect_to svie_edit_path unless current_user.primary_membership
  end

  def create
    current_user.update(svie_state: :ELFOGADASALATT)
    redirect_to profiles_me_path, notice: t(:applied_succesful)
  end

  def edit
    @svie_memberships = current_user.memberships.select { |m| m.group.issvie && !m.newbie? }
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
end
