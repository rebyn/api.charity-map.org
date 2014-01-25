class AddBreakDownToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :break_down, :hstore
  end
end
