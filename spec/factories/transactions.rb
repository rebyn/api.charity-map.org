# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  uid             :string(255)
#  amount          :float
#  status          :string(255)
#  expiry_date     :datetime
#  sender_email    :string(255)
#  recipient_email :string(255)
#  currency        :string(255)
#  references      :text
#  created_at      :datetime
#  updated_at      :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    uid "0123456789"
    amount 100000
    created_at "2014-01-08 22:16:54"
    updated_at "2014-01-08 22:16:54"
    sender_email "tu@charity-map.org"
    recipient_email "individual@gmail.com"
    currency "VND"
  end
end
