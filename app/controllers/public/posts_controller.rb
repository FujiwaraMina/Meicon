class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def new
    @post_new = Post.new
    @tag_list = @post_new.tags.pluck(:tag_name).join(',')
  end

  def index
    @post = Post.page(params[:page]).per(15)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    # @post_tags = @post.tags
  end

  def create
    @post_new = Post.new(post_params)
    @post_new.user_id = current_user.id
    tag_list=params[:post][:tag_name].split(',')
    if @post_new.save
      @post_new.save_tag(tag_list)
      flash[:notice] = "投稿しました"
      redirect_to post_path(@post_new)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name).join(',')
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to posts_path
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split
    # もしpostの情報が更新されたら
    if @post.update(post_params)
      # このpost_idに紐づいていたタグを@oldに入れる
      @old_relations=PostTag.where(post_id: @post.id)
       # それらを取り出し消去
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tag(tag_list)
      flash[:notice] = "投稿を編集しました"
      redirect_to post_path
    else
      render :edit
    end
  end

  def search
    # 検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    # 検索されたタグに紐づく投稿を表示
    @posts = @tag.posts.page(params[:page]).per(15)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end
end
