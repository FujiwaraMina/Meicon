class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :post_imege
  #コメント関連付け
  has_many :comments, dependent: :destroy
  #いいね関連付け
  has_many :favorite, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
