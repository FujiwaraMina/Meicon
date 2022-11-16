class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_post_path
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_user_path(@post.user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end
end
