class PostComment < ApplicationRecord
    #1対多のリレーション
    #belongs_to :post
    #belongs_to :profile

    #validates :post_id, presence: true
    #validates :profile_id, presence: true
    validates :comment_text, presence: true

    #profile情報を取得するメソッド
    def profile
        return Profile.find_by(user_id: self.profile_id)
    end

    #post画像アップロード設定
    #複数の場合
    mount_uploaders :comment_image, CommentImageUploader
    serialize :comment_image, JSON
end
