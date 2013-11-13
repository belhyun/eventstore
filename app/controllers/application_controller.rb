class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper :all
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :js_load

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?
  def js_load
    @js_controller = controller_name
    @js_action = action_name
  end
end
