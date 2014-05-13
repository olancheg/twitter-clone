module FriendshipSupport
  extend ActiveSupport::Concern

  included do
    has_many :outgoing_friend_requests, class_name: :Friendship, foreign_key: :sender_id
    has_many :incoming_friend_requests, class_name: :Friendship, foreign_key: :recipient_id
  end

  def friends
    @friends ||= User.where("id IN #{friend_id_sql}")
  end

  def friend_ids
    friends.pluck(:id)
  end

  def send_friend_request(user)
    outgoing_friend_requests.create!(sender: self, recipient: user)
  end

  def cancel_friendship(user)
    outgoing_friend_requests.where(recipient_id: user).destroy_all
  end

  def is_a_friend?(user)
    friends.include?(user)
  end

  def has_incoming_friend_request?(user)
    incoming_friend_requests.where(sender_id: user).exists?
  end

  def has_outgoing_friend_request?(user)
    outgoing_friend_requests.where(recipient_id: user).exists?
  end

  def incoming_requests_count
    incoming_friend_requests.count - friends.count
  end

  def outgoing_requests_count
    outgoing_friend_requests.count - friends.count
  end

private

  def friend_id_sql
    left_part  = self.incoming_friend_requests.select('sender_id AS id')
    right_part = self.outgoing_friend_requests.select('recipient_id AS id')

    left_part.intersect(right_part).to_sql
  end
end
