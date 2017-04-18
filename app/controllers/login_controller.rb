class LoginController < ApplicationController

  def login
  end

  def logout
    reset_session
    redirect_to root_url
  end

end
