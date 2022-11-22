class Favorite < ApplicationRecord
  # 会員はいいねを多数所持する
  belongs_to :user
  # 投稿はいいねを多数所持する
  belongs_to :post
end