class SvieController < ApplicationController
  before_action :require_login

  def edit
    @svie_memberships = current_user.memberships.find { |m| m.issvie }
  end

  def update
  end

end
