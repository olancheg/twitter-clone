class Friendship < ActiveRecord::Base
  attr_accessible :sender, :recipient

  belongs_to :sender, class_name: :User
  belongs_to :recipient, class_name: :User

  validates :sender_id, uniqueness: { scope: :recipient_id }
  validate :recipient_is_self?

private

  def recipient_is_self?
    errors.add(:recipient_id, :invalid) if sender_id == recipient_id
  end
end
