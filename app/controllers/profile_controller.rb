class ProfileController < ApplicationController

  def show
  	if session[:user]
    	@user = User.find(session[:user])
    else
    	redirect_to '/auth/oauth'
    end
  end

  def settings
    if session[:user]
      @user = User.find(session[:user])
    else
      redirect_to '/auth/oauth'
    end
    if params[:rawPhoto]
      raw_photo = params[:rawPhoto]
      File.open(Rails.root.join('public', 'uploads', raw_photo.original_filename), 'wb') do |file|
        file.write(raw_photo.read)
      end
      @raw_photo = raw_photo.original_filename
    end
  end

end
