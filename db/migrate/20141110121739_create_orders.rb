class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :code
      t.date :reference_date
      t.references :store, index: true
      t.float :total, precision: 2
      t.string :reference_state

      t.timestamps
    end
  end
end
