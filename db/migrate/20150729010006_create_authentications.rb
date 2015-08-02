class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps null: false
    end

    add_index :user, unique: true
  end
end
