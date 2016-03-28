class Article < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :title, :category, :body, presence: true
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, "should be less than 2MB")
      end
    end
end
