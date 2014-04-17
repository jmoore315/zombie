class Message < ActiveRecord::Base
  belongs_to :account
  belongs_to :messageable, polymorphic: true
  validates :content, presence: true
  validates :sender_email, presence: true

end