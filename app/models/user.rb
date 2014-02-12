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
  attr_accessible :email, :name, :contact, :category
  validates :email, :category, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, uniqueness: true
  validate :user_to_belong_to_a_category
  has_defaults category: "INDIVIDUAL"

  after_create :generate_auth_token

  has_many :credits
  has_one :auth_token

  def user_to_belong_to_a_category
    errors.add(:category, "has to be either Merchant, Individual or SocialOrg") if
      ["MERCHANT", "INDIVIDUAL", "SOCIALORG"].index(category) == nil
  end

  def is?(cat)
    self.category == cat ? true : false
  end

  def transactions
    Transaction.where(sender_email: email)
  end

  def generate_auth_token
    self.create_auth_token if !self.auth_token
  end
end
