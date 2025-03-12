class CreateJournalEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :journal_entries do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :account_type, null: false
      t.integer :amount, null: false # will be normalized to cents
      t.string :entry_type, null: false
      t.boolean :balanced, null: false, default: false

      t.timestamps
    end

    add_index :journal_entries, :entry_type
    add_index :journal_entries, :balanced
  end
end
