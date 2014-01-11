# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    value "MyString"
    transaction_id "MyString"
    expiry_date "2014-01-10 22:01:50"
    status "MyString"
  end
end
