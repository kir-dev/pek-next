class ImAccountsController < ApplicationController
  before_action :require_login

  def update
    @im_account = ImAccount.find(params[:id])
    respond_to do |format|
      if @im_account.update(im_account_params)
        format.json { head :no_content }
        format.js
      end
    end
  end

  def create
    @im_account = ImAccount.new(im_account_params)
    respond_to do |format|
      if @im_account.save
        format.json { render json: @im_account, status: :created, location: @im_account }
        format.js
      end
    end
  end

  def destroy
    @im_account = ImAccount.find(params[:id])
    @im_account.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

  private
    def im_account_params
      params.require(:im_account).permit(:protocol, :name, :user_id)
    end
end
