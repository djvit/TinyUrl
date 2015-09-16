# Sessions controller
class SessionsController < ApplicationController

  # Skip CSRF for JSON
  skip_before_filter :verify_authenticity_token

  # Authorization
  before_filter :authorize, :only => :destroy

  # Show sign up form
  def show
  end

  # Sign-in action
  def create
    user = User.find_by_email(session_params[:email])

    # If the user exists AND the password entered is correct.
    if user && user.authenticate(session_params[:password])
      user.signin

      render json: { access_token: user.access_token, email: user.email }, status: :ok
    else
      render json: { message: 'Incorrect email or password'  }, status: :unauthorized
    end
  end

  # Sign-out action
  def destroy
    if @current_user
      @current_user.signout

      @current_user = nil

      render json: { message: 'success' }, status: :ok
    else
      render json: { message: 'No permission for this method'  }, status: :unauthorized
    end
  end

  # Parameters sanitization
  private

  def session_params
    params.require(:session).permit(:email, :password, :access_token)
  end
end
