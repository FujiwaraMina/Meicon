class Post < ApplicationRecord
  #ユーザ関連付け
  belongs_to :user
  has_one_attached :post_image
  #コメント関連付け
  has_many :comments, dependent: :destroy
  #いいね関連付け
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  #投稿の画像定義付け
  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      post_image.attach(io: File.open(file_path),filename:'default-image.jpg', content_type:'image/jpeg')
    end
    post_image.variant(resize_to_limit:[width,height]).processed
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
