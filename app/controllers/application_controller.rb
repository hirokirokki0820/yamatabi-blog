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

  #404エラー, 500エラーの扱い
  if !Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  # def routing_error
  #   raise ActionController::RoutingError.new(params[:path])
  # end

  # 404エラーページの表示
  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      format = params[:format] == :json ? :json : :html
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end
  end

  # 500エラーページの表示
  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      format = params[:format] == :json ? :json : :html
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  protected
  # Devise
  def configure_permitted_parameters
    # アカウント編集の時にnameとprofileのストロングパラメータを追加
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :avatar])
    # サインアップ時にnameのストロングパラメータを追加
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
