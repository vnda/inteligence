class AddJsonPayloadToReports < ActiveRecord::Migration
  def change
    add_column :monthly_reports, :payload, :json
    add_column :state_reports, :payload, :json
    add_column :abc_curve_reports, :payload, :json
  end
end
