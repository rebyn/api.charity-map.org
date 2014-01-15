# == Schema Information
#
# Table name: tokens
#
#  id             :integer          not null, primary key
#  value          :string(255)
#  transaction_id :string(255)
#  expiry_date    :datetime
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Token do
  pending "add some examples to (or delete) #{__FILE__}"
end
