class Post < ApplicationRecord
  #ユーザ関連付け
  belongs_to :user
  has_one_attached :post_image
  #コメント関連付け
  has_many :comments, dependent: :destroy
  #いいね関連付け
  has_many :favorites, dependent: :destroy
  #投稿の画像、タイトル、キャプションが存在するかどうかのバリデーション
  validates :post_image, presence: true
  validates :title, presence: true
  validates :body, presence: true

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
end
