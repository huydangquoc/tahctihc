class Message < ApplicationRecord
  validates :body, presence: true
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  def mark_as_read!
    self.read_at = Time.now
    save!
  end

  def read?
    read_at
  end

  scope :unread, -> { where(read_at: nil) }

  scope :belong_to_me, -> (user) do
    where("messages.recipient_id = ?", user.id)
  end

  scope :sent_by_me, -> (user) do
    where("messages.sender_id = ?", user.id)
  end

end
