class StoreUpdateMonthlyReportsWorker
  include Sidekiq::Worker

  def perform(id)
    store = Store.find(id)
    store.update_monthly_reports
    puts "Updated monthly reports for #{store.name}"
  end
end