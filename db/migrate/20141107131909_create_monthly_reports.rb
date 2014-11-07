class CreateMonthlyReports < ActiveRecord::Migration
  def change
    create_table :monthly_reports do |t|
      t.date :reference_date
      t.integer :orders_count
      t.float :orders_yield
      t.float :average_ticket
      t.integer :items_count
      t.references :store, index: true

      t.timestamps
    end
  end
end
