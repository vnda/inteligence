class StateWorker
  include Sidekiq::Worker

  def perform(store_id, start_date, end_date, email)
    store = Store.find_by(id: store_id)
    start_dt = Date.parse(start_date)
    end_dt = Date.parse(end_date)
    reports = store.state_report_for(start_dt, end_dt)
    VndaAPI::Drive.create_state_report_spreedsheet(store, reports, start_dt, end_dt, email)
  end
end