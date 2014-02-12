# == Schema Information
#
# Table name: auth_tokens
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auth_token do
    value "MyString"
    status "MyString"
    user nil
  end
end
