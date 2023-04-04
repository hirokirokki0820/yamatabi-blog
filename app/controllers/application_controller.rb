class ApplicationController < ActionController::Base
  # Adminユーザーのみ許可
  def require_admin_user
    if current_user != user_signed_in? && !current_user.admin?
      flash[:alert] = "管理者以外の投稿・編集は許可されていません。"
      redirect_to root_path
    end
  end
end
