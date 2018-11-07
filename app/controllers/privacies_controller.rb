class PrivaciesController < ApplicationController
  def update
    user = User.find(params[:user])
    privacy = Privacy.for(user, params[:attribute])
    privacy.update(visible: params[:visible])
  end
end
