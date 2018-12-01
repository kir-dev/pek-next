class RawPhotosController < ApplicationController
  def show
    send_file PhotoService.raw_path(current_user.screen_name),
              type: 'image/png', disposition: 'inline'
  end

  def update
    unless params[:rawPhoto]
      return redirect_back fallback_location: edit_profile_path(current_user.screen_name),
                           alert: 'Nincs kép kiválasztva'
    end

    PhotoService.upload_raw(current_user.screen_name, params[:rawPhoto])
    redirect_to edit_photo_path(current_user.screen_name)
  end
end
