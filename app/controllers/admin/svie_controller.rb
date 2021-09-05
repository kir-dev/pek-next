module Admin
  class SvieController < ApplicationController
    before_action :authorize_user

    def index
      @post_requests = SviePostRequest.all
    end

    def approve
      svie_post_request = SviePostRequest.find(params[:id])
      @user = svie_post_request.user
      @user.update(svie_member_type: svie_post_request.member_type)
      svie_post_request.destroy
    end

    def reject
      svie_post_request = SviePostRequest.destroy(params[:id])
      @user = svie_post_request.user
    end

    private

    def authorize_user
      authorize :application, :manage_SVIE?
    end
  end
end
