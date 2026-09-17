class CreateQuantityChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :quantity_changes do |t|
      t.references :die, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :new_quantity_before, null: false
      t.integer :new_quantity_after, null: false
      t.integer :used_quantity_before, null: false
      t.integer :used_quantity_after, null: false

      t.timestamps
    end

    add_index :quantity_changes, [:die_id, :created_at]
  end
end
