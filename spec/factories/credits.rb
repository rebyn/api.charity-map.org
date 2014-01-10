# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    master_transaction_id "MyString"
    amount 1.5
    belongs_to ""
    status "MyString"
  end
end
