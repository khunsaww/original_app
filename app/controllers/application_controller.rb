class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_current_user

  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = session[:user_id] && User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "ログインしてください"
  end

  def require_admin
    return if admin?

    redirect_to root_path, alert: "この操作は管理者のみ実行できます"
  end

  def set_current_user
    Current.user = current_user
  end
end
