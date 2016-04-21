class Comment < ActiveRecord::Base
  belongs_to :article
  before_save { self.email = email.downcase }
  validates :article_id, :content, :name, :parent, presence: true
  default_scope -> { order(created_at: :desc) }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  
end
