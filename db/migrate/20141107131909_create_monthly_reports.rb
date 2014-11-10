class CreateMonthlyReports < ActiveRecord::Migration
  def change
    create_table :monthly_reports do |t|
      t.date :reference_date
      t.integer :orders_count
      t.float :orders_yield, precision: 2
      t.float :average_ticket, precision: 2
      t.integer :average_itens
      t.references :store, index: true

      t.timestamps
    end
  end
end
