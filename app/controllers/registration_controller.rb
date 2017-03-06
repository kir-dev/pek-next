class RegistrationController < ApplicationController
  
  def new
  end

  def create
    oauth_data = session[:oauth_data]
    user = User.create(usr_auth_sch_id: oauth_data["internal_id"],
      email: oauth_data["mail"],
      firstname: oauth_data["givenName"], 
      lastname: oauth_data["sn"],
      screen_name: request.params[:username],
      dormitory: request.params[:dormitory],
      room: request.params[:room][0])
    if(!user.valid?)
      @error = { expected: true }
      if user.errors.messages[:usr_screen_name]
        @error[:message] = t(:username_taken)
      elsif user.errors.messages[:usr_auth_sch_id]
        @error[:message] = t(:auth_sch_id_taken)
      elsif euser.errors.messages[:usr_bme_id]
        @error[:message] = t(:bme_id_taken)
      end
      new
      render :new
    else
      session[:user] = user.id
      session.delete(:oauth_data)
      redirect_to root_url
    end
  end

end
