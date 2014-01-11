class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column :transactions, :status, :string, :default => "not_authorized"
  end
end
