class PostComment < ApplicationRecord
    #1対多のリレーション
    belongs_to :post
    belongs_to :profile

    #validates :post_id, presence: true
    #validates :profile_id, presence: true
    validates :comment_text, presence: true

    #profile情報を取得するメソッド
    def get_profile_id
        return Profile.find_by(id: self.profile_id)
    end

    #scopeを定義
    scope :filter_by_post, ->(post_id) { where(post_id: post_id) if post_id }

    #post画像アップロード設定
    #複数の場合
    mount_uploaders :comment_image, CommentImageUploader
    serialize :comment_image, JSON
end
