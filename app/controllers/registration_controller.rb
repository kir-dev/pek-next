class RegistrationController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    oauth_data = session[:oauth_data]
    oauth_params = {
      auth_sch_id: oauth_data['internal_id'],
      email: oauth_data['mail'],
      firstname: oauth_data['givenName'],
      lastname: oauth_data['sn'],
      neptun: oauth_data['niifPersonOrgID']
    }
    @user = User.create(create_params.merge(oauth_params))
    if @user.valid?
      session[:user_id] = @user.id
      session.delete(:oauth_data)
      AuthSchPingbackService.call(session[:access_token])
      redirect_to root_url, notice: t(:register_successful)
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:user).permit(:screen_name, :dormitory, :room)
  end
end
