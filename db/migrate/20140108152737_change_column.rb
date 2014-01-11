class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column :transactions, :status, :string
  end
end
