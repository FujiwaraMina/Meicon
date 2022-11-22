class Post < ApplicationRecord
  #ユーザは投稿を多数所持する
  belongs_to :user
  # 1対１(単数枚画像投稿)で関連付け
  has_one_attached :post_image
  #コメント関連付け
  has_many :comments, dependent: :destroy
  #いいね関連付け
  has_many :favorites, dependent: :destroy
  #タグと投稿の中間テーブル関連付け
  has_many :post_tags, dependent: :destroy
  #タグ関連づけ
  has_many :tags, through: :post_tags
  #投稿の画像、タイトル、キャプションが存在するかどうかのバリデーション
  validates :post_image, presence: true
  validates :title, presence: true
  validates :body, presence: true
  # 会員がいいねしてるかどうか
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  #投稿の画像定義付け
  def get_post_image(width,height)
    # 画像を持っていない場合
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      post_image.attach(io: File.open(file_path),filename:'default-image.jpg', content_type:'image/jpeg')
    # 画像を持っている場合
    end
    post_image.variant(resize_to_fill:[width,height]).processed
  end
  #検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?", "%#{word}%")
    else
      @post = Post.all
    end
  end
  # タグの保存,消去
  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags
    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end
    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_post_tag
   end
  end
end