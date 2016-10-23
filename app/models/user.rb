class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_insensitive: false}
  has_secure_password
  has_many :friends, through: :friendships
  has_many :friendships

  def self.all_except user
    where.not(id: user)
  end

  def self.not_friend current_user
    friend_ids = current_user.friends.pluck(:friend_id)
    friend_ids.push(current_user.id)
    User.where.not(id: friend_ids)
  end

end
