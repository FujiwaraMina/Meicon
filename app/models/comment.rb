class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  #コメントが存在するかどうかのバリデーション
  validates :comment, presence: true
end
