class RegistrationController < ApplicationController
  
  def new
  end

  def create
    oauth_data = session[:oauth_data]
    oauth_params = {
      usr_auth_sch_id: oauth_data["internal_id"],
      email: oauth_data["mail"],
      firstname: oauth_data["givenName"], 
      lastname: oauth_data["sn"]
    }
    user = User.create(create_params.merge(oauth_params))
    if(!user.valid?)
      @errors = user.errors
      render :new
    else
      session[:user_id] = user.id
      session.delete(:oauth_data)
      redirect_to root_url, notice: t(:register_successful)
    end
  end

  private

  def create_params
    params.require(:user).permit(:screen_name, :dormitory, :room)
  end

end
