# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  master_transaction_id :string(255)
#  amount                :float
#  belongs_to            :integer
#  status                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Credit < ActiveRecord::Base
	attr_accessible :id, :master_tranasction_id, :amount, :belongs_to, :status

	validates :id, :master_tranasction_id, :amount, :belongs_to, :status, presence: true
	validates :amount, :numericality => true
	
	belongs_to :transaction
  has_defaults status: "NEW"

end
