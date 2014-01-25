# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  master_transaction_id :string(255)
#  amount                :float
#  user_id               :integer
#  status                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  uid                   :string(255)
#  currency              :string(255)
#

require 'spec_helper'

describe Credit do
  pending "add some examples to (or delete) #{__FILE__}"
end
