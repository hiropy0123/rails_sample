class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  # CarrierWaveを利用して、PictureUploaderを追加
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  # ↑単数形のvalidate

  private
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "サイズは最大で5MBまで")
      end
    end

end
