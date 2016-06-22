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
  end

  def picture
    send_file cropped_path(params[:username]), type: 'image/png', disposition: 'inline'
  end
  
  def save_settings
    @user.firstname = params['firstName']
    @user.lastname = params['lastName']
    @user.nickname = params['nickname']
    @user.gender = params['gender']
    @user.date_of_birth = params['dateOfBirth'] #FIXME meg kell nénzni, hohy jó formátumba jön-e
    @user.home_address = params['homeAddress']
    @user.email = params['emailAddress']
    @user.webpage = params['webpage']
    @user.cell_phone = params['cellPhone']
    @user.webpage = params['webpage']
    @user.dormitory = params['dormitory']
    @user.room = params['room']

    @user.save
    
    redirect_to "/settings"
    # a fentieket nem lenne egyszerűbb valami osztályon keresztül behúzni? 
    #  és akkor csak annyi lenne, hogy: User=post
  end

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
