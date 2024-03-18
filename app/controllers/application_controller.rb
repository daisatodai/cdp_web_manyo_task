class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from Exception, with: :render_500

  include SessionsHelper
  before_action :login_required
  before_action :set_current_user

  private
  def set_current_user
    @current_user = current_user
  end

  def login_required
    redirect_to new_session_path, notice: 'ログインしてください' unless current_user
  end

  def logout_required
    if logged_in?
      redirect_to tasks_path,
      notice: 'ログアウトしてください'
    end
  end

  # def render_404(exception = nil)
  #   if exception
  #     logger.info "Rendering 404 with exception: #{exception.message}"
  #   end
  #   render template: "errors/error_404", status: 404, layout: 'application'
  # end

  # def render_500(exception = nil)
  #   if exception
  #     logger.info "Rendering 500 with exception: #{exception.message}"
  #   end
  #   render template: "errors/error_500", status: 500, layout: 'application'
  # end
end
