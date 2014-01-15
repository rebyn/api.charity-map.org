require 'spec_helper'

describe Transaction do
  it "has a token after_create" do
    transaction = FactoryGirl.create :transaction
    transaction.token.value.length.should eq(22)
  end
end
