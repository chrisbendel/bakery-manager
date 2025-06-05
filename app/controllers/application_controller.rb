class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :set_current_session
  # TODO require user on everything, and explicitly skip for public routes?
  #  OR explicitly require on bakery owner/admin routes separately
  before_action :require_user

  helper_method :current_user

  private

  def set_current_session
    Current.session = Session.find_by_id(cookies.signed[:session_token])
  end

  def require_user
    unless current_user
      redirect_to sign_in_url, alert: "Please sign in to continue"
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def current_user
    Current.user
  end
end
