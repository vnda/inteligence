class MonthlyWorker
  include Sidekiq::Worker

  def perform(store_id, start_date, end_date, email)
    store = Store.find_by(id: store_id)
    start_dt = Date.parse(start_date)
    end_dt = Date.parse(end_date)
    reports = store.monthly_report_for(start_dt, end_dt)
    drive_url = VndaAPI::Drive.create_monthly_report_spreedsheet(store, reports, start_dt, end_dt, email)
    store.monthly_reports.create(start: start_date, end: end_date, drive_url: drive_url)
  end
end