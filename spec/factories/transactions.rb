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
#  break_down      :hstore
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    amount 100000
    created_at "2014-01-08 22:16:54"
    updated_at "2014-01-08 22:16:54"
    sender_email "merchant@company.com"
    recipient_email "cuong@individual.net"
    currency "VND"
    break_down { {"1234567890" => 100000} }
  end
end
