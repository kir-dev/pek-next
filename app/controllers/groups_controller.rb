class GroupsController < ApplicationController
  before_action :authorize_group

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
    @can_manage_memberships = policy(@viewmodel.group).manage_memberships?

    @memberships = Membership.includes(:post_types)
                             .includes(user: :svie_post_request, posts: :post_type)
                             .where(group_id: params[:id])
    @active_memberships = MembershipCollectionDecorator.new(@memberships.active.page(params[:active_users_page]))
    @inactive_memberships = MembershipCollectionDecorator.new(@memberships.inactive.page(1))
    @archived_memberships = MembershipCollectionDecorator.new(@memberships.archived.page(1))
  end

  def edit; end

  def update
    if current_group.update(update_params)
      redirect_to current_group, notice: t(:edit_successful)
    else
      render :edit
    end
  end

  def new
    @parent_groups = Group.type_resort
  end

  def create
    leader = User.find(params[:selected_user_id])
    group  = CreateGroup.call(create_params, leader, current_user)

    redirect_to group_path(group)
  end

  private

  def update_params
    params.require(:group)
          .permit(:name, :description, :webpage, :founded, :maillist,
                  :users_can_apply, :archived_members_visible)
  end

  def create_params
    params.require(:group).permit(%i[name parent_id issvie type])
  end

  def authorize_group
    authorize current_group, policy_class: GroupPolicy
  end
end
