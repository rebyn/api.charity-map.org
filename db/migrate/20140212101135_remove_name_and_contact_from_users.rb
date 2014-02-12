class RemoveNameAndContactFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name
    remove_column :users, :contact
  end
end
