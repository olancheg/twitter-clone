class Tweet < ActiveRecord::Base
  attr_accessible :body

  validates :body, presence: true, length: { maximum: 140 }

  belongs_to :user
  has_many :comments, order: 'created_at DESC'

  delegate :username, :realname, to: :user, prefix: true, allow_nil: true
end
