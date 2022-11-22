class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 1対１(単数枚)で関連付け
  has_one_attached :user_image
  #投稿関連付け
  has_many :posts, dependent: :destroy
  #コメント関連付け
  has_many :comments, dependent: :destroy
  #いいね関連付け
  has_many :favorites, dependent: :destroy
  #フォローした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #フォロー一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #会員のニックネーム、メールアドレス、パスワードが存在するかどうかのバリデーション
  validates :name, presence: true
  validates :email, presence: true
  validates :encrypted_password, presence: true
  #フォローした時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #フォローを外す時の処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
  #ゲストログイン機能
  def self.guest
    find_or_create_by!(name:'guestuser',email:'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  #ユーザー画像定義付け
  def get_user_image(width,height)
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      user_image.attach(io:File.open(file_path),filename:'default-image.jpg',content_type:'image/jpeg')
    end
    user_image.variant(resize_to_fill:[width,height]).processed
  end
  #検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end