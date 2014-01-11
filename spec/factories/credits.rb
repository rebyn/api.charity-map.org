# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  master_transaction_id :string(255)
#  amount                :float
#  belongs_to            :integer
#  status                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    master_transaction_id "MyString"
    amount 1.5
    belongs_to ""
    status "MyString"
  end
end
