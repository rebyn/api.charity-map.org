class AddUidToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :uid, :string
  end
end
