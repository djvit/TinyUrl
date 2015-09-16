# Urls conroller
class UrlsController < ApplicationController
  # Skip CSRF for JSON
  skip_before_filter :verify_authenticity_token

  # Authorization
  before_filter :authorize, :only => :create

  # Add URL form
  def show
  end

  # Add new URL
  def create
    url = Url.new(url_params)
    url.user = @current_user
    if url.save
      render json: { tiny_path: url.tiny_path }, status: :ok
    else
      render json: { message: url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Render redirection to tiny URL or show an error message
  def access
    if params['tiny_path'].length == 5
      url = Url.find_by(:tiny_path => params['tiny_path'])
      if url
        redirect_to url.path
      else
        @error_message = 'Tiny URL not found'
      end
    else
      @error_message = 'Invalid tiny URL'
    end
  end

  # Parameters sanitization
  private

  def url_params
    params.require(:url).permit(:path)
  end

end
