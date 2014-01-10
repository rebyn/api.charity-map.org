class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.string :transaction_id
      t.timestamp :expiry_date
      t.string :status

      t.timestamps
    end
  end
end
