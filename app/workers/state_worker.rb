class StateWorker
  include Sidekiq::Worker

  def perform(store_id, start_date, end_date, email)
    store = Store.find_by(id: store_id)
    start_dt = Date.parse(start_date)
    end_dt = Date.parse(end_date)
    reports = state_report_for(start_dt, end_dt)
    drive_url = VndaAPI::Drive.create_state_report_spreedsheet(self, reports, start_dt, end_dt, email)
    store.state_reports.create(start: start_dt, end: end_dt, drive_url: drive_url)      
  end
end