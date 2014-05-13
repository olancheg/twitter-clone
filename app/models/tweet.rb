class Tweet < ActiveRecord::Base
  attr_accessible :body

  validates :body, presence: true, length: { maximum: 140 }

  belongs_to :user
  has_many :comments, order: 'created_at DESC'

  paginates_per 10

  def add_comment(params, user)
    comment = comments.build(params)
    comment.user = user
    comment.save
    comment
  end
end
