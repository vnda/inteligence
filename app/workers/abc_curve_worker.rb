class AbcCurveWorker
  include Sidekiq::Worker

  def perform(store_id, start_date, end_date, email)
    store = Store.find_by(id: store_id)
    start_dt = Date.parse(start_date)
    end_dt = Date.parse(end_date)
    reports = abc_curve_report_for(start_dt, end_dt, email)
    drive_url = VndaAPI::Drive.create_abc_curve_report_spreedsheet(self, reports, start_dt, end_dt)
    store.abc_curve_reports.create(start: start_dt, end: end_dt, drive_url: drive_url)
  end
end