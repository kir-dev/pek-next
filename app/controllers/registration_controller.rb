class RegistrationController < ApplicationController
  
  def new
    @dorms = Rails.configuration.x.dorms
  end

  def create_user
    oauth_data = session[:oauth_data]
    begin
      user = User.create(usr_auth_sch_id: oauth_data["internal_id"],
        email: oauth_data["mail"],
        firstname: oauth_data["givenName"], 
        lastname: oauth_data["sn"],
        screen_name: request.params[:username],
        dormitory: request.params[:dormitory],
        room: request.params[:room])
    rescue ActiveRecord::RecordNotUnique => e
      @error = { expected: true }
      if e.message.include? "users_usr_screen_name_key"
        @error[:message] = "Ez a felhasználónév már foglalt!"
      elsif e.message.include? "users_usr_auth_sch_id_key"
        @error[:message] = "Ezzel az auth.sch id-val már regisztráltak!"
      elsif e.message.include? "users_usr_bme_id_key"
        @error[:message] = 'Ezzel a BME id-val már regisztráltak!'
      end
      new()
      render :new
    rescue ActiveRecord::ActiveRecordError => e
      @error = { message: "Váratlan probléma történt!" }
      new()
      render :new
    else
      session[:user] = user.id
      session.delete(:oauth_data)
      redirect_to root_url
    end
  end

end
