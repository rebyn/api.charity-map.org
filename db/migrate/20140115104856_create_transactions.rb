class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :uid
      t.float :amount
      t.string :status
      t.datetime :expiry_date
      t.string :sender_email
      t.string :recipient_email
      t.string :currency
      t.text :references

      t.timestamps
    end
  end
end
