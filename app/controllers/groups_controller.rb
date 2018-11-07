class GroupsController < ApplicationController
  before_action :require_leader, only: %I[edit update]

  def index
    active_groups = Group.order(:name).reject(&:inactive?)
    active_groups = GroupDecorator.decorate_collection(active_groups)
    @groups = Kaminari.paginate_array(active_groups)
                      .page(params[:page]).per(items_per_page)
  end

  def all
    @groups = Group.order(:name).page(params[:page])
                   .per(items_per_page).decorate
    render :index
  end

  def show
    membership_view_model = MembershipViewModel.new(current_user, params[:id])
    @viewmodel = MembershipViewModelDecorator.decorate(membership_view_model)
  end

  def edit; end

  def update
    if current_group.update(update_params)
      redirect_to current_group, notice: t(:edit_successful)
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:group)
          .permit(:name, :description, :webpage, :founded, :maillist,
                  :users_can_apply, :archived_members_visible)
  end
end
