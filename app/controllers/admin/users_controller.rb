class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(admin_user_params)
    redirect_to admin_user_path
  end

  private

  def admin_user_params
    params.require(:user).permit(:user_image, :name, :user_caption, :email)
  end
end
