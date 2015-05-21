class Collaboration < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :post, class_name: "Post"

  validates :post_id, presence: true
  validates :user_id, presence: true
end
