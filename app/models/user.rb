class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_insensitive: false}
  has_secure_password

  def self.all_except(user)
    where.not(id: user)
  end

end
