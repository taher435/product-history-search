class CreateProductHistories < ActiveRecord::Migration
  def up
    create_table :product_histories, id: false do |t|
      t.integer :product_id
      t.string :product_type, limit: 50
      t.bigint :unix_ts
      t.text :attribute_changes

      t.timestamps null: false
    end
  end

  def down
    drop_table :product_histories
  end
end
