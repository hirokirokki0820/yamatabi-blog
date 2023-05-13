class ApplicationController < ActionController::Base
  # deviseコントローラーにストロングパラメータを追加する
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Adminユーザーのみ許可
  def require_admin_user
    if current_user != user_signed_in? && !current_user.admin?
      flash[:alert] = "管理者以外の投稿・編集は許可されていません。"
      redirect_to root_path
    end
  end

  # ログインユーザーのみ許可
  def require_login
    redirect_to new_user_session_path if !user_signed_in?
  end

  protected
  def configure_permitted_parameters
    # アカウント編集の時にnameとprofileのストロングパラメータを追加
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :avatar])
    # サインアップ時にnameのストロングパラメータを追加
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
