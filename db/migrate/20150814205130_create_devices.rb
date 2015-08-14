class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.text :description
      t.text :items
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
