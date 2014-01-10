class ChangeColumnExpiryDateToDatetime < ActiveRecord::Migration
  def change
  	change_column :tokens, :expiry_date, :datetime
  end
end
