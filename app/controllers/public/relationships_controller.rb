class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  #フォローする時
  def create
    @word = params[:word]
    @search = params[:search]
    @users = User.all
    @users_search = User.looks(params[:search], params[:word])
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
  end
  #フォロー外す時
  def destroy
    @word = params[:word]
    @search = params[:search]
    @users = User.all
    @users_search = User.looks(params[:search], params[:word])
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
  end
  #フォロー一覧
  def followings
    @user = User.find(params[:user_id])
    @user_followings = @user.followings.page(params[:page]).per(10)
  end
  #フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @user_followers = @user.followers.page(params[:page]).per(10)
  end
end