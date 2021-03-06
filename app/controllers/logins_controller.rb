class LoginsController < ApplicationController
  def show
    @login = Login.new
  end

  def create
    @login = Login.new(login_params)

    if @login.valid? && @login.authenticated?
      session[:current_user_id] = @login.user.id
      redirect_to root_path, success: "You are successfully logged in."
    else
      render :show
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path, success: "You are successfully logged out."
  end

  private

  def login_params
    params.require(:login).permit(:email, :password, :bio, :location, :github_url, :so_url, :twitter_url)
  end
end
