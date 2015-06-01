class StoreUpdateDailyReportsWorker
  include Sidekiq::Worker

  def perform(id)
    store = Store.find(id)
    store.update_daily_reports
    puts "Updated daily reports for #{store.name}"
  end
end