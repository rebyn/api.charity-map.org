class Credit < ActiveRecord::Base
  belongs_to :user
  attr_accessible :master_transaction_id, :amount, :user_id

  validates :id, :master_transaction_id, :amount, :user_id, :status, presence: true
  validates :amount, :numericality => true
  
  has_defaults status: "UNPROCESSED"
end
