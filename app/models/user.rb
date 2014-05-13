class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :realname

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :tweets, order: 'created_at DESC'
  has_many :comments

  include FriendshipSupport
  include BlacklistSupport

  scope :search, ->(options) do
    query = '%' + options[:q].to_s + '%'
    where('username ILIKE ? OR realname ILIKE ?', query, query)
  end

  paginates_per 10

  def feed
    Tweet.where(user_id: friend_ids)
  end
end
