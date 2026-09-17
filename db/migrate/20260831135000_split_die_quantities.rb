class SplitDieQuantities < ActiveRecord::Migration[7.1]
  def up
    add_column :dies, :new_quantity, :integer, null: false, default: 0
    add_column :dies, :used_quantity, :integer, null: false, default: 0

    execute "UPDATE dies SET new_quantity = quantity"

    remove_column :dies, :quantity
  end

  def down
    add_column :dies, :quantity, :integer, null: false, default: 0
    execute "UPDATE dies SET quantity = new_quantity + used_quantity"
    remove_column :dies, :new_quantity
    remove_column :dies, :used_quantity
  end
end
