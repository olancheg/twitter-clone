class Friendship < ActiveRecord::Base
  attr_accessible :sender, :recipient

  belongs_to :sender, class_name: :User
  belongs_to :recipient, class_name: :User

  validates :sender_id, uniqueness: { scope: :recipient_id }
  validate :recipient_is_self?
  validate :recipient_is_banned_user?

  scope :without_sender_ids,    ->(ids) { where arel_table[:sender_id].not_in(ids) }
  scope :without_recipient_ids, ->(ids) { where arel_table[:recipient_id].not_in(ids) }

  paginates_per 10

private

  def recipient_is_self?
    errors.add(:recipient_id, :invalid) if sender_id == recipient_id
  end

  def recipient_is_banned_user?
    errors.add(:recipient_id, :invalid) if recipient && recipient.banned_user_ids.include?(sender_id)
  end
end
