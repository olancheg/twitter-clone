class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :realname

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :tweets
  has_many :comments
end
