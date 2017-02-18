class PhotosController < ApplicationController
  before_action :require_login

  def show
    send_file PhotoService.cropped_path(params[:id]), type: 'image/png', disposition: 'inline'
  end

  def update
    PhotoService.upload_cropped(current_user.screen_name,Base64.decode64(params[:croppedData].split(',')[1]))

    respond_to do |format|
      format.json {render json: {status: "success"}}
    end
  end

  def edit
  end
end
