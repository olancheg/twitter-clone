class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :realname

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :tweets, order: 'created_at DESC'
  has_many :comments

  has_many :bans
  has_many :banning_users, through: :bans, foreign_key: :target_id, source: :user
  has_many :banned_users, through: :bans, source: :target

  has_many :outgoing_friend_requests, class_name: :Friendship, foreign_key: :sender_id
  has_many :incoming_friend_requests, class_name: :Friendship, foreign_key: :recipient_id

  scope :search, ->(options) do
    query = '%' + options[:q].to_s + '%'
    where('username ILIKE ? OR realname ILIKE ?', query, query)
  end

  paginates_per 10

  def friends
    @friends ||= User.where("id IN #{friend_id_sql}")
  end

  def friend_ids
    friends.pluck(:id)
  end

  def send_friend_request(user)
    outgoing_friend_requests.create!(sender: self, recipient: user)
  end
  alias :accept_friend_request :send_friend_request

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

  def add_to_banlist(user)
    # add to list
    banned_users << user

    # terminate outgoing friend request
    cancel_friendship(user)
  end

  def feed
    Tweet.where(user_id: friend_ids)
  end

private

  def friend_id_sql
    left_part  = self.incoming_friend_requests.select('sender_id AS id')
    right_part = self.outgoing_friend_requests.select('recipient_id AS id')

    left_part.intersect(right_part).to_sql
  end
end
