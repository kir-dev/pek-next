module Admin
  class DelegatesController < ApplicationController
    before_action :require_svie_admin

    def export
      @delegates = User.includes([{ primary_membership: [:group] }])
                       .where(delegated: true)
                       .order(:lastname)
                       .select { |user| user.primary_membership.group.issvie }
    end

    def count
      CountDelegates.new.call
      redirect_back fallback_location: '/', notice: t(:successful_count)
    end
  end
end
