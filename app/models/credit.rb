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
#  uid                   :string(255)
#  currency              :string(255)
#

class Credit < ActiveRecord::Base
  scope :unprocessed, -> { where(status: "UNPROCESSED") }
  scope :cleared, -> { where(status: "CLEARED") }
  belongs_to :user
  attr_accessible :uid, :master_transaction_id, :amount, :user_id, :status, :currency

  before_validation :generate_uid, :unless => :uid?

  validates :uid, :master_transaction_id, :amount, :user_id, :status, :currency, presence: true
  validates :amount, :numericality => true
  validate :credit_to_belong_to_a_master_transaction
  
  has_defaults status: "UNPROCESSED"

  def credit_to_belong_to_a_master_transaction
    errors.add(:master_transaction_id, "has to belong to a Transaction") if !Transaction.exists?(uid: master_transaction_id)
  end

  def generate_uid
    self.uid = loop do
      random_uid = (0..9).map{ ('0'..'9').to_a[rand(10)] }.join
      break random_uid unless Credit.exists?(uid: random_uid)
    end
  end

  def url
    return "#{BASE_URI}/credits/#{self.uid}"
  end

  def merchant
    @transaction = Transaction.find_by_uid(self.master_transaction_id)
    @merchant = User.find_by(email: @transaction.sender_email)
    return @merchant
  end
end