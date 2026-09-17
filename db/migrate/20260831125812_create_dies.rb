class CreateDies < ActiveRecord::Migration[7.1]
  def change
    create_table :dies do |t|
      t.string :name, null: false
      t.string :product_code, null: false
      t.string :size
      t.string :category
      t.references :location, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.integer :unit_price, null: false, default: 0
      t.date :purchase_date
      t.text :notes

      t.timestamps
    end

    add_index :dies, :name
    add_index :dies, :product_code
    add_index :dies, :category
  end
end
