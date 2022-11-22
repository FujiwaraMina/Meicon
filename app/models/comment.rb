class Comment < ApplicationRecord
  # 会員はコメントを多数所持する
  belongs_to :user
  # 投稿はコメントを多数所持する
  belongs_to :post
  #コメントが存在するかどうかのバリデーション
  validates :comment, presence: true
end
