class Profile < ApplicationRecord
    #1対1のリレーション destroyメソッドで関連付けユーザーも削除
    belongs_to :user, dependent: :destroy
    has_many :post_like, dependent: :destroy
    has_many :post_comment, dependent: :destroy

    validates :user_id, presence: true
    validates :profile_name, presence: true

    #profile画像アップロード設定
    mount_uploader :profile_image, ProfileImageUploader

    #profileカバー画像アップロード設定
    mount_uploader :profile_cover_image, ProfileCoverImageUploader

end
