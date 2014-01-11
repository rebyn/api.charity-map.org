class ChangeColumnTokenStatus < ActiveRecord::Migration
  def change
  	change_column :tokens, :status, :string, :default => "new"
  end
end
