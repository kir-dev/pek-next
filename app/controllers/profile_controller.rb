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
      @genders = '{"UNKNOWN", "MALE", "FEMALE", "NOTSPECIFIED"}'#FIXME
    else
      redirect_to '/auth/oauth'
    end
    if params[:rawPhoto]
      raw_photo = params[:rawPhoto]
      dircheck(photo_dir(@user.screen_name))
      File.open(raw_path(@user.screen_name), 'wb') do |file|
        file.write(raw_photo.read)
      end
      @raw_photo = raw_photo.original_filename
    end
  end

  def upload
    @user = User.find(session[:user])
    dircheck(photo_dir(@user.screen_name))

    File.open(cropped_path(@user.screen_name), 'wb') do |file|
      file.write(Base64.decode64(params[:croppedData].split(',')[1]))
    end

    respond_to do |format|
      format.json {render json: {status: "success"}}
    end
  
  def new
    @user = User.new
  end

  def picture
    send_file cropped_path(params[:username]), type: 'image/png', disposition: 'inline'
  end
  def save_settings
    raise
    @user = User post
    post[:firstName]
    post[:lastName]
    post[:nickName]

    # a fentieket nem lenne egyszerűbb valami osztályon keresztül behúzni? 
    #  és akkor csak annyi lenne, hogy: User=post

  def dircheck (dirname)
    if !Dir.exists?(dirname)
      Dir.mkdir(dirname)
    end
  end

  def raw_path (screen_name)
    return photo_dir(screen_name).join('raw.png')
  end

  def cropped_path (screen_name)
    return photo_dir(screen_name).join('cropped.png')
  end

  def photo_dir (screen_name)
    return Rails.root.join(Rails.configuration.x.photo_path, screen_name)
  end
end
