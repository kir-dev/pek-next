class ProfilesController < ApplicationController
  before_action :correct_user, only: %i[edit update update_view_setting]
  before_action :set_entities_for_edit, only: %i[edit]

  def show
    user = User.includes([{ pointrequests: [{ evaluation: %i[group entry_requests] }] },
                          { memberships: %i[group post_types] }]).find_by(screen_name: params[:id])
    return redirect_to profiles_me_path unless user

    @user_presenter = user.decorate
  end

  def show_by_id
    user = User.find_by(id: params[:id])
    return redirect_to profiles_me_path, alert: t(:virid_not_found) unless user

    redirect_to profile_path(user.screen_name)
  end

  def show_self
    @user_presenter = current_user.decorate
    render :show
  end

  def edit; end

  def update
    if current_user.update(user_params)
      return redirect_to profiles_me_path, notice: t(:edit_successful)
    end

    set_entities_for_edit
    render :edit
  end

  def update_view_setting
    @view_setting = ViewSetting.find_or_initialize_by(user: current_user)
    if @view_setting.update(view_setting_params)
      return redirect_to profiles_me_path, notice: t(:edit_successful)
    end

    redirect_back fallback_location: edit_profile_path(current_user, anchor: 'view-settings')
  end

  private

  def set_entities_for_edit
    @im_account = ImAccount.new
    @user = current_user
    @view_setting = @user.view_setting
    @view_setting ||= ViewSetting.new
  end

  def user_params
    params.require(:profile)
          .permit(:firstname, :lastname, :nickname, :cell_phone, :date_of_birth,
                  :home_address, :email, :webpage, :dormitory, :room, :gender)
  end

  def view_setting_params
    params.require(:view_setting).permit(:listing, :show_pictures, :items_per_page)
  end
end
