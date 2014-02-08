# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  contact    :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :contact, :category
  validates :email, :category, presence: true
  validate :user_to_belong_to_a_category
  has_defaults category: "INDIVIDUAL"

  after_create :generate_auth_token

  has_many :credits
  has_one :auth_token

  def user_to_belong_to_a_category
    errors.add(:category, "has to be either Merchant, Individual or SocialOrg") if
      ["MERCHANT", "INDIVIDUAL", "SOCIALORG"].index(category) == nil
  end

  def is_merchant?
    category == "MERCHANT" ? true : false
  end

  def is_individual?
    category == "INDIVIDUAL" ? true : false
  end

  def generate_auth_token
    if !self.auth_token && self.category == "MERCHANT"
      self.create_auth_token expiry_date: (Time.now + 90.days)
    end
  end
end