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
