class SessionsController < ApplicationController
  def new
    if session.has_key? :user_id
     redirect_to admins_path
    end
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
      session[:user_id] = user.id
      redirect_to admins_path
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to sign_in_path, :notice => "Logged out!"
  end
end
