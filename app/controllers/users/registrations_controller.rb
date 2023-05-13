# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    # 自分で設定した「マイページ」へのパス
    users_mypage_path
  end

end
