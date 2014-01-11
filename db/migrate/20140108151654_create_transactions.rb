class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :uid
      t.float :amount
      t.datetime :created_at
      t.datetime :updated_at
      t.string :status

      t.timestamps
    end
  end
end
