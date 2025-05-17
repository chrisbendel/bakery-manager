class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password]))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: "Signin Successful"
    else
      flash.now[:alert] = "That email or password is incorrect"
      render turbo_stream: turbo_stream.replace(
        "sign_in_form",
        partial: "sessions/form",
        locals: { email_hint: params[:email] }
      )
    end
  end


  def destroy
    @session.destroy
    redirect_to sessions_path, notice: "Logged out"
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
