class PhotosController < ApplicationController
  before_action :require_login

  def show
    sanitized = params[:id].gsub(/^.*(\\|\/)/, '')
    send_file PhotoService.cropped_path(sanitized), type: 'image/png', disposition: 'inline'
  end

  def update
    PhotoService.upload_cropped(current_user.screen_name,Base64.decode64(params[:croppedData].split(',')[1]))

    respond_to do |format|
      format.json {render json: {status: "success"}}
    end
  end

  def edit
    redirect_to(edit_profile_path) unless PhotoService.rawcheck(current_user.screen_name)
  end
end
