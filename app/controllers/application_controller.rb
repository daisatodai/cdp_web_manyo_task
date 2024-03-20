class ApplicationController < ActionController::Base
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

  def set_user
    @user = User.find(params[:id])
  end
end
