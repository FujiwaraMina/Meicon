class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
    @favorite_posts = Kaminari.paginate_array(@favorite_posts).page(params[:page]).per(15)
  end

  def followers
    @user = User.find(params[:id])
  end

  def followings
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_image, :user_caption, :email)
  end
end