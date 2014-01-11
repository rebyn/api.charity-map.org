# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  uid         :string(255)
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string(255)
#  expiry_date :datetime
#

require 'spec_helper'

describe Transaction do
  pending "add some examples to (or delete) #{__FILE__}"
end
