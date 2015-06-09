class SeedSkuReportsWorker
  include Sidekiq::Worker

  def perform(id)
    store = Store.find(id)
    beginning_of_day = DateTime.now.beginning_of_day - 1.day
    end_of_day = DateTime.now.end_of_day - 1.day

    start_date, end_date, date_type = beginning_of_day, end_of_day, "daily"
    sku_curve = store.sku_curve_report_for(start_date, end_date)
    store.sku_curve_reports << SkuCurveReport.new(start: start_date, end: end_date, payload: sku_curve.to_json, date_type: date_type)
    
    start_date, end_date, date_type = beginning_of_day - 15.days, end_of_day, "weekly"
    sku_curve = store.sku_curve_report_for(start_date, end_date)
    store.sku_curve_reports << SkuCurveReport.new(start: start_date, end: end_date, payload: sku_curve.to_json, date_type: date_type)

    start_date, end_date, date_type = beginning_of_day - 30.days, end_of_day, "monthly"
    sku_curve = store.sku_curve_report_for(start_date, end_date)
    store.sku_curve_reports << SkuCurveReport.new(start: start_date, end: end_date, payload: sku_curve.to_json, date_type: date_type)
    
    puts "Updated daily reports for #{store.name}"
  end
end