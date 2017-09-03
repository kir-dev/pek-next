class DelegatesController < ApplicationController
  before_action :require_login

  def index
#    @delegates = Membership.find { |ms| ms.user.delegated == true }
     #.order(:name).page(params[:page]).per(params[:per]) ()
    @all_fckin_user = User.where(delegated: 'true').order(:firstname).page(params[:page]).per(params[:per])
  end

end