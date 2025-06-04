class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  def new
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password]))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      Current.session = @session
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password"
      @email_hint = params[:email]
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Current.session&.destroy
    cookies.delete(:session_token)
    redirect_to root_path
  end
end
