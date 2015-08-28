class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :line_item_id
      t.references :item, index: true, foreign_key: {on_delete: :cascade}
      t.references :order, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps null: false
    end
  end
end
