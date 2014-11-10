class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true
      t.integer :quantity
      t.string :reference
      t.string :name
      t.float :price, precision: 2

      t.timestamps
    end
  end
end
