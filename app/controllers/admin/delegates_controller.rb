module Admin
  class DelegatesController < ApplicationController
    before_action :require_svie_admin

    def count
      CountDelegates.new.call
      redirect_back fallback_location: '/', notice: t(:successful_count)
    end
  end
end
