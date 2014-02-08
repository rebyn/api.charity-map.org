class AddExpiryDateToAuthToken < ActiveRecord::Migration
  def change
    add_column :auth_tokens, :expirty_date, :date
  end
end
