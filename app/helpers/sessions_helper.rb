module SessionsHelper

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    @current_user.admin == true
    # NOTE: ログインしているユーザがadmin or adminじゃないかのtrue or falseを返すものをここにここに作る
  end

  def current_user?(user)
    user == current_user
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
