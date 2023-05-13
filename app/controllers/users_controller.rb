class UsersController < ApplicationController
before_action :authenticate_user!, only: %i[ mypage ]
  def show
    @user = User.find(params[:id])
  end

  def mypage
    @user = current_user
  end
end
