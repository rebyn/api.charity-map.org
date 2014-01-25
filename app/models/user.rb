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
  attr_accessible :email, :name, :contact
  validates :email, :category, presence: true
  validate :user_to_belong_to_a_category
  has_defaults category: "INDIVIDUAL"

  has_many :credits

  def user_to_belong_to_a_category
    errors.add(:category, "has to be either Merchant, Individual or SocialOrg") if
      ["MERCHANT", "INDIVIDUAL", "SOCIALORG"].index(category) == nil
  end
end
