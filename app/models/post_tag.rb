class PostTag < ApplicationRecord
  # 投稿とタグの中間テーブル
  belongs_to :post
  belongs_to :tag

  validates :post_id, presence: true
  validates :tag_id, presence: true
end
