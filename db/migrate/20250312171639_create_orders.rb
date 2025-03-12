class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :batch, null: false, foreign_key: true
      t.integer :external_order_id
      t.datetime :ordered_at
      t.string :item_type
      t.decimal :price_per_item, precision: 10, scale: 2
      t.integer :quantity
      t.decimal :shipping, precision: 10, scale: 2
      t.decimal :tax_rate, precision: 5, scale: 3
      t.string :payment_1_id
      t.decimal :payment_1_amount, precision: 10, scale: 2
      t.string :payment_2_id
      t.decimal :payment_2_amount, precision: 10, scale: 2
      t.text :raw_data, null: false # Store full row data for debugging or auditing

      t.timestamps
    end
  end
end
