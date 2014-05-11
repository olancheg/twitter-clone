class Comment < ActiveRecord::Base
  attr_accessible :body

  validates :body, presence: true, length: { maximum: 140 }

  belongs_to :tweet
  belongs_to :user

  delegate :username, to: :user, prefix: true
end
