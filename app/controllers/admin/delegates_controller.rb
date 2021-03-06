module Admin
  class DelegatesController < ApplicationController
    before_action :require_svie_admin

    def index
      groups = Group.order(:name)
      @groups_with_delegates, @groups_without_delegates =
        groups.partition { |group| group.delegate_count.positive? }
      @groups_without_delegates = @groups_without_delegates.select(&:issvie)
    end

    def export
      @delegates = User.includes([{ primary_membership: [:group] }])
                       .where(delegated: true)
                       .order(:lastname)
                       .select { |user| user.primary_membership.group.issvie }
    end

    def update
      Group.find(params[:group_id]).update(delegate_count: params[:delegate_count])
      redirect_back fallback_location: admin_delegates_path, notice: t(:edit_successful)
    end

    def count
      CountDelegates.new.call
      redirect_to admin_delegates_path, notice: t(:successful_count)
    end
  end
end
