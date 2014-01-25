# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  contact    :string(255)
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
