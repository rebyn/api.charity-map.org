class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.string :master_transaction_id
      t.float :amount
      t.references :user, index: true
      t.string :status

      t.timestamps
    end
  end
end
