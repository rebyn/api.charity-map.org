# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :email
  validates :email, :category, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, uniqueness: true
  validate :user_to_belong_to_a_category
  has_defaults category: 'INDIVIDUAL'

  before_validation :sanitize_email_input
  after_create :generate_auth_token

  has_many :credits
  has_one :auth_token

  def sanitize_email_input
    sanitized = email.strip
    self.email = sanitized
  end

  def user_to_belong_to_a_category
    errors.add(:category, 'has to be either Merchant, Individual or SocialOrg') if
      %w(MERCHANT INDIVIDUAL SOCIALORG).index(category).nil?
  end

  def is?(cat)
    category == cat ? true : false
  end

  def transactions
    Transaction.where(sender_email: email)
  end

  def generate_auth_token
    create_auth_token unless auth_token
  end
end
