class SvieController < ApplicationController
  before_action :require_login

  def new
    # redirect_to svie_edit_path

    # then redirect back to here
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
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end

end
