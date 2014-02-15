# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  it "should not allow duplicate accounts" do
    user = FactoryGirl.create(:user)
    another_user = User.create email: user.email
    another_user.should_not be_valid
  end
end
