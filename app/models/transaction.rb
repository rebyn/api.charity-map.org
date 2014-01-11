# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  uid         :string(255)
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)
#  expiry_date :datetime
#

class Transaction < ActiveRecord::Base
	attr_accessible :id, :uid, :amount, :created_at, :updated_at, :status

	before_validation :generate_uid, :unless => :uid?

	validates :uid, :amount, :created_at, :status, presence: true
	validates :amount, :numericality => true

	has_one :token
	has_many :credits
  has_defaults status: "NotAuthorized"

	private
	def generate_uid
		self.uid = loop do
      random_uid = SecureRandom.urlsafe_base64(nil, false)
      break random_uid unless Transaction.exists?(uid: random_uid)
    end
	end
end
