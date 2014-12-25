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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    master_transaction_id 'MyString'
    amount 1.5
    user nil
    status 'MyString'
  end
end
