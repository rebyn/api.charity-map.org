# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  master_transaction_id :string(255)
#  amount                :float
#  user_id               :integer
#  status                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Credit < ActiveRecord::Base
  belongs_to :user
  attr_accessible :master_transaction_id, :amount, :user_id

  validates :master_transaction_id, :amount, :user_id, :status, presence: true
  validates :amount, :numericality => true
  validate :credit_to_belong_to_a_master_transaction
  
  has_defaults status: "UNPROCESSED"

  def credit_to_belong_to_a_master_transaction
    errors.add(:master_transaction_id, "has to belong to a Transaction") if !Transaction.exists?(uid: master_transaction_id)
  end
end
