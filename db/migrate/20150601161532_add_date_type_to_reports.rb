class AddDateTypeToReports < ActiveRecord::Migration
  def change
    add_column :monthly_reports, :date_type, :string
    add_column :state_reports, :date_type, :string
    add_column :abc_curve_reports, :date_type, :string
  end
end
