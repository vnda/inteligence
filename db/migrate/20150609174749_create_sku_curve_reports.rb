class CreateSkuCurveReports < ActiveRecord::Migration
  def change
    create_table :sku_curve_reports do |t|
      t.references :store, index: true
      t.date :start
      t.date :end
      t.string :drive_url
      t.json :payload
      t.string :date_type

      t.timestamps
    end
  end
end
