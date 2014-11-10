class CreateAbcCurveReports < ActiveRecord::Migration
  def change
    create_table :abc_curve_reports do |t|
      t.references :store, index: true
      t.string :reference
      t.string :name
      t.integer :quantity
      t.float :price, precision: 2
      t.float :total_price, precision: 2

      t.timestamps
    end
  end
end
