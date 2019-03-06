class Post < ApplicationRecord

    #1対多のリレーション
    has_many :post_like, dependent: :destroy
    has_many :post_comment, dependent: :destroy
    
    #profile情報を取得するメソッド
    def profile
        return Profile.find_by(user_id: self.profile_id)
    end

    validates :profile_id, presence: true
    validates :post_text, presence: true

    #post画像アップロード設定
    #mount_uploader :post_image, PostImageUploader

    #複数の場合
    mount_uploaders :post_image, PostImageUploader
    serialize :post_image, JSON

end
