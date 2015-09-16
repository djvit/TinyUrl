# Base Application Controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Error handling
  rescue_from Exception, :with => :handle_error

  # Authentication handler
  def authorize
    token = request.headers['Access-Token']
    @current_user ||= User.find_by(:access_token => token) if token

    render json: { message: 'Invalid access token'  }, status: :unauthorized unless @current_user
  end

  private
  # Error handler
  def handle_error(e)
    render json: { message: e.message }, status: :unprocessable_entity and return
  end
end
