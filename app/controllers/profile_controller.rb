require 'fileutils'

class ProfileController < ApplicationController
  before_action :require_login

  def show
  end

  def settings
    if params[:rawPhoto]
      raw_photo = params[:rawPhoto]
      dircheck(photo_dir(@user.screen_name))
      File.open(raw_path(@user.screen_name), 'wb') do |file|
        file.write(raw_photo.read)
      end
      @raw_photo = "uploads/" + @user.screen_name[0, 1] + "/" + @user.screen_name + "/raw.png";
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
  end

  def picture
    send_file cropped_path(params[:username]), type: 'image/png', disposition: 'inline'
  end

  def dircheck (dirname)
    if !Dir.exists?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  def raw_path (screen_name)
    return photo_dir(screen_name).join('raw.png')
  end

  def cropped_path (screen_name)
    return photo_dir(screen_name).join('cropped.png')
  end

  def photo_dir (screen_name)
    return Rails.root.join(Rails.configuration.x.photo_path, screen_name[0, 1], screen_name)
  end

end
