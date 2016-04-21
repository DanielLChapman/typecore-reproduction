class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :user_id, :title, :category, :body, :tag, presence: true
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  is_impressionable
  
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, "should be less than 2MB")
      end
    end
end
