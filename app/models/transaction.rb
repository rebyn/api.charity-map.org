class Transaction < ActiveRecord::Base
  BASE_URI = "https://api.charity-map.org"

  scope :authorized, -> { where(status: "Authorized") }
  attr_accessible :id, :uid, :sender_email, :recipient_email,
    :amount, :expiry_date, :currency, :reference

  before_validation :generate_uid, :unless => :uid?
  after_create :generate_token

  validates :uid, :sender_email, :recipient_email,
    :amount, :status, :currency, presence: true
  validates :amount, :numericality => true

  has_one :token
  has_many :credits
  has_defaults status: "NotAuthorized", references: ""

  def url
    return "#{BASE_URI}/transactions/#{self.uid}"
  end

  def authorized?
    return true if self.status == 'Authorized'
    false
  end

  private

  def sender
    User.find_by_email(self.sender_email)
  end

  def recipient
    User.find_by_email(self.recipient_email)
  end

  def generate_uid
    self.uid = loop do
      random_uid = (0..9).map{ ('0'..'9').to_a[rand(10)] }.join
      break random_uid unless Transaction.exists?(uid: random_uid)
    end
  end

  def generate_token
    if !self.token
      self.create_token expiry_date: (Time.now + 30.days)
    end
  end
end
