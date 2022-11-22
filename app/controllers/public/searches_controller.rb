class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word]).page(params[:page]).per(10)
    elsif @range == "Tag"
      @tags = Tag.looks(params[:search], params[:word]).page(params[:page]).per(15)
    else
      @posts = Post.looks(params[:search], params[:word]).page(params[:page]).per(15)
    end
  end
end