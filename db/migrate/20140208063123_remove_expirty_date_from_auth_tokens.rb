class RemoveExpirtyDateFromAuthTokens < ActiveRecord::Migration
  def change
    remove_column :auth_tokens, :expirty_date
  end
end
