class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password]))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      Current.session = @session
      redirect_to root_path, notice: "Signin Successful"
    else
      flash.now[:alert] = "That email or password is incorrect"
      redirect_to sign_in_url(email_hint: params[:email])
    end
  end


  def destroy
    Current.session&.destroy
    redirect_to root_path, notice: "Logged out"
  end
end
