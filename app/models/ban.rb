class Ban < ActiveRecord::Base
  attr_accessible :user, :target

  belongs_to :user
  belongs_to :target, class_name: :User
end
