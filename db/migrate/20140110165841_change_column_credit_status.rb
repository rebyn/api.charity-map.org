class ChangeColumnCreditStatus < ActiveRecord::Migration
  def change
  	change_column :credits, :status, :string, :default => "new"
  end
end
