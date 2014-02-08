class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.string :value
      t.string :status
      t.references :user, index: true

      t.timestamps
    end
  end
end
