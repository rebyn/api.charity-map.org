# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  uid         :string(255)
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)
#  expiry_date :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    uid "MyString"
    amount 1.5
    created_at "2014-01-08 22:16:54"
    updated_at "2014-01-08 22:16:54"
    status "MyString"
  end
end
