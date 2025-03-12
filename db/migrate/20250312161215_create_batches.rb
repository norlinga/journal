class CreateBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :batches do |t|
      t.string :status, null: false, default: 'pending'
      t.datetime :processed_at

      t.timestamps
    end
    add_index :batches, :status
  end
end
