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

require 'spec_helper'

describe Transaction do
  it "has a token after_create" do
    transaction = FactoryGirl.create :transaction
    transaction.token.value.length.should eq(22)
  end
end
