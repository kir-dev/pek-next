require 'fileutils'

class ProfileController < ApplicationController
  before_action :require_login

  def show
  end

  def settings
    @dorms = Rails.configuration.x.dorms
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
  
  def save_settings
    
    if /^[0-9\+][0-9\-]+$/.match(params['cellPhone']) != nil or params['cellPhone'] == ''
      @user.firstname = params['firstName']
      @user.lastname = params['lastName']
      @user.nickname = params['nickname']
      @user.gender = params['gender']
      @user.date_of_birth = params['dateOfBirth'] #FIXME meg kell nénzni, hohy jó formátumba jön-e
      @user.home_address = params['homeAddress']
      @user.email = params['emailAddress']
      @user.webpage = params['webpage']

      @user.cell_phone = /^[0-9\+][0-9\-]+$/.match(params['cellPhone'])
      @user.webpage = params['webpage']
      @user.dormitory = params['dormitory']
      @user.room = params['room']

      @user.save
    # a fentieket nem lenne egyszerűbb valami osztályon keresztül behúzni? 
    #  és akkor csak annyi lenne, hogy: User=params
      redirect_to "/settings"
    else
      @error = { expected: true }
      @error[:message] = "Hibás telefonszám formátum. Ellenőrizd, hogy +36201234567 formátumú legyen!"
      render :settings
    end

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
