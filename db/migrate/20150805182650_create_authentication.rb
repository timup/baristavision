class CreateAuthentication < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.string :merchant_id
      t.string :token
      t.boolean :expires
      t.datetime :expires_at
      t.references :user, foreign_key: true

      t.timestamps null: false
    end

    add_index :authentications, :user_id, unique: true
  end
end
