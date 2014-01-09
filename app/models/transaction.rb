# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  uid									:string
#  amount								:float
#  created_at						:datetime
#  updated_at						:datetime
#  status								:string 					{not_authorized, authorized}
class Transaction < ActiveRecord::Base
	attr_accessible :id, :uid, :amount, :created_at, :updated_at, :status

	before_validation :generate_uid, :unless => :uid?

	validates :uid, :amount, :created_at, :status, presence: true

	private
	def generate_uid
		self.uid = loop do
      random_uid = SecureRandom.urlsafe_base64(nil, false)
      break random_uid unless Transaction.exists?(uid: random_uid)
    end
	end

end
