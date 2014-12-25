# == Schema Information
#
# Table name: tokens
#
#  id             :integer          not null, primary key
#  value          :string(255)
#  transaction_id :string(255)
#  expiry_date    :datetime
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    value 'MyString'
    transaction_id 'MyString'
    expiry_date '2014-01-15 17:49:33'
    status 'MyString'
  end
end
