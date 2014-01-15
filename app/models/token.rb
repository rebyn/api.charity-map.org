class Token < ActiveRecord::Base
  attr_accessible :value, :transaction_id, :expiry_date, :status

  before_validation :generate_value, :unless => :value?

  validates :value, :transaction_id, :expiry_date, :status, presence: true  

  belongs_to :transaction
  has_defaults status: "NEW"

  private
  def generate_value
    self.value = loop do
      random_value = SecureRandom.urlsafe_base64(nil, false)
      break random_value unless Token.exists?(value: random_value)
    end
  end
end
