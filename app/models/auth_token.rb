# == Schema Information
#
# Table name: auth_tokens
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class AuthToken < ActiveRecord::Base
  attr_accessible :value, :user_id, :status
  before_validation :generate_value, on: :create
  validates :value, :user_id, :status, presence: true
  has_defaults status: 'ACTIVE'
  belongs_to :user

  private

  def generate_value
    self.value = loop do
      random_value = SecureRandom.urlsafe_base64(nil, false)
      break random_value unless AuthToken.exists?(value: random_value)
    end
  end
end
