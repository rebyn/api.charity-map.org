class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.string :transaction_id
      t.datetime :expiry_date
      t.string :status

      t.timestamps
    end
  end
end
