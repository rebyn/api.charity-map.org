class User < ActiveRecord::Base
  attr_accessible :email
  validates :email, :category, presence: true
  validate :user_to_belong_to_a_category
  has_defaults category: "INDIVIDUAL"

  has_many :credits

  def user_to_belong_to_a_category
    errors.add(:category, "has to be either Merchant, Individual or SocialOrg") if
      ["MERCHANT", "INDIVIDUAL", "SOCIALORG"].index(category) == nil
  end
end
