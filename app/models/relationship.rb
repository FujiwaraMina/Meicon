class Relationship < ApplicationRecord
  # 会員はフォローもフォロワーも多数所持する
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
