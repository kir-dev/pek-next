require 'fileutils'

class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
  end

  def show_self
    @user = current_user
    render :show
  end

  def settings
    if params[:rawPhoto]
      raw_photo = params[:rawPhoto]
      dircheck(photo_dir(current_user.screen_name))
      File.open(raw_path(current_user.screen_name), 'wb') do |file|
        file.write(raw_photo.read)
      end
      @raw_photo = raw_path
    end
  end

  def upload
    current_user = User.find(session[:user])
    dircheck(photo_dir(current_user.screen_name))

    File.open(cropped_path(current_user.screen_name), 'wb') do |file|
      file.write(Base64.decode64(params[:croppedData].split(',')[1]))
    end

    respond_to do |format|
      format.json {render json: {status: "success"}}
    end
  end

  def picture
    send_file cropped_path(params[:username]), type: 'image/png', disposition: 'inline'
  end

  def save_settings
    current_user.update(params.permit(:firstname, :lastname, :nickname, :gender, :date_of_birth, :home_address, :email, :webpage, :dormitory, :room))

    phone_regex = /^[0-9\+][0-9\-]+$/.match(params['cell_phone'])

    if phone_regex or params['cell_phone'] == ''
      current_user.cell_phone = phone_regex
      current_user.save
      redirect_to "/settings"
    else
      @error = { expected: true }
      @error[:message] = I18n.t 'error.wrong_phone_number'
      render :settings
    end
  end

  private

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
