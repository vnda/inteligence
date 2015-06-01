class StoreUpdateWeeklyReportsWorker
  include Sidekiq::Worker

  def perform(id)
    store = Store.find(id)
    store.update_weekly_reports
    puts "Updated weekly reports for #{store.name}"
  end
end