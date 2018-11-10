class PhotosController < ApplicationController
  def show
    sanitized = params[:id].gsub(%r{^.*(\\|/)}, '')
    send_file PhotoService.photo_path(sanitized), type: 'image/png', disposition: 'inline'
  end

  def update
    PhotoService.upload_cropped(current_user.screen_name,
                                Base64.decode64(params[:croppedData].split(',')[1]))

    respond_to do |format|
      format.json { render json: { status: 'success' } }
    end
  end

  def edit
    return if PhotoService.raw_check(current_user.screen_name)

    redirect_to edit_profile_path(anchor: 'profile-picture')
  end
end
