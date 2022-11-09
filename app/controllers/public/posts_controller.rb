class Public::PostsController < ApplicationController
  def new
    @post_new = Post.new
  end

  def index
    @post = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post)
  end

  def edit
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def update
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end
end
