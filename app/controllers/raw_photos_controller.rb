class RawPhotosController < ApplicationController
  before_action :require_login

  def show
    send_file PhotoService.raw_path(current_user.screen_name), type: 'image/png', disposition: 'inline'
  end

  def update
    PhotoService.upload_raw(current_user.screen_name, params[:rawPhoto])
    @raw_photo_path = "egy"

    redirect_to edit_photo_path(current_user.screen_name)
  end
end
