# Users controller
class UsersController < ApplicationController

  # Skip CSRF for JSON
  skip_before_filter :verify_authenticity_token

  # Show sign up form
  def show
  end

  # Create new user / Sign-up
  def create
    user = User.new(user_params)
    if user.save
      render json: { id: user.id, email: user.email }, status: :ok
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Parameters sanitization
  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
