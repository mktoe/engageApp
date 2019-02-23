class PostLike < ApplicationRecord
    #1対多のリレーション destroyメソッドで関連付けユーザーも削除
    belongs_to :post
    belongs_to :profile

    validates :post_id, presence: true
    validates :profile_id, presence: true
end
