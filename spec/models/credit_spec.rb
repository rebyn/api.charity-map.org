# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  master_transaction_id :string(255)
#  amount                :float
#  belongs_to            :integer
#  status                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe Credit do
  pending "add some examples to (or delete) #{__FILE__}"
end
