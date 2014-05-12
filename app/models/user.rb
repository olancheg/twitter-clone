class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :realname

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :tweets
  has_many :comments

  has_many :outgoing_friend_requests, class_name: :Friendship, foreign_key: :sender_id
  has_many :incoming_friend_requests, class_name: :Friendship, foreign_key: :recipient_id

  def friends
    @friends ||= begin
      left_part  = self.incoming_friend_requests.select('sender_id AS id')
      right_part = self.outgoing_friend_requests.select('recipient_id AS id')
      subquery   = left_part.intersect(right_part).to_sql

      User.where("id IN #{subquery}")
    end
  end

  def send_friend_request(user)
    outgoing_friend_requests.create!(sender: self, recipient: user)
  end
  alias :accept_friend_request :send_friend_request
end
