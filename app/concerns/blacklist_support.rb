module BlacklistSupport
  extend ActiveSupport::Concern

  included do
    has_many :bans
    has_many :inverse_bans, foreign_key: :target_id, class_name: :Ban

    has_many :banning_users, through: :inverse_bans, source: :user
    has_many :banned_users, through: :bans, source: :target
  end

  def add_to_blacklist(user)
    banned_users << user
    cancel_friendship(user)
  end

  def remove_from_blacklist(user)
    bans.where(target_id: user).destroy_all
  end
end
