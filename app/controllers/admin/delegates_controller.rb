module Admin
  class DelegatesController < ApplicationController
    before_action :require_svie_admin

    def index
      groups = Group.order(:name).reject(&:inactive?)
      @groups_with_delegates, @groups_without_delegates =
        groups.partition { |group| group.delegate_count.positive? }
      @groups_without_delegates = @groups_without_delegates.select(&:issvie)
    end

    def export
      groups = Group.includes(memberships: [:group, user: :primary_membership, posts: :post_type])
                    .order(:name).reject(&:inactive?)
                    .select { |group| group.delegate_count.positive? }
      group_delegates = groups.map do |group|
        group.memberships.select do |membership|
          membership.primary? && membership.user.delegated
        end.map(&:user)
      end
      @delegates = group_delegates.flatten
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
