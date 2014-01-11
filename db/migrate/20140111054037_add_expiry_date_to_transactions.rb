class AddExpiryDateToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :expiry_date, :datetime
  end
end
