# == Schema Information
#
# Table name: auth_tokens
#
#  id           :integer          not null, primary key
#  value        :string(255)
#  status       :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  expirty_date :date
#

require 'spec_helper'

describe AuthToken do
  pending "add some examples to (or delete) #{__FILE__}"
end
