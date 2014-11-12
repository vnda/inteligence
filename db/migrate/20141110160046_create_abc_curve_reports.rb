class CreateAbcCurveReports < ActiveRecord::Migration
  def change
    create_table :abc_curve_reports do |t|
      t.references :store, index: true
      t.date :start
      t.date :end
      t.string :drive_url

      t.timestamps
    end
  end
end
