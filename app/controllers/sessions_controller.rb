class SessionsController < ApplicationController

  def new
    if signed_in?
      redirect_to @current_user
    end
  end

  def create
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      redirect_to new_session_path
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
