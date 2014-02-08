# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auth_token do
    value "MyString"
    status "MyString"
    user nil
  end
end
