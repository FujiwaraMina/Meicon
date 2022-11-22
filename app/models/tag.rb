class Tag < ApplicationRecord
  has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
  #post_tagを通じて投稿を参照する
  has_many :posts,through: :post_tags

  validates :tag_name, uniqueness: true, presence: true
  # タグ検索関連付け
  def self.looks(search, word)
    if search == "perfect_match"
      @tag = Tag.where("tag_name LIKE?", "#{word}")
    elsif search == "forward_match"
      @tag = Tag.where("tag_name LIKE?","#{word}%")
    elsif search == "backward_match"
      @tag = Tag.where("tag_name LIKE?","%#{word}")
    elsif search == "partial_match"
      @tag = Tag.where("tag_name LIKE?","%#{word}%")
    else
      @tag = Tag.all
    end
  end

end
