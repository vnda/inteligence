class FullUpdateWorker
  include Sidekiq::Worker

  #This worker only should be evoked manually... 
  def perform(id)
    store = Store.find(id)
    store.update_full_daily_reports
    puts "Fully Updated daily reports for #{store.name}"
    store.update_full_weekly_reports
    puts "Fully Updated weekly reports for #{store.name}"
    store.update_full_monthly_reports
    puts "Fully Updated monthly reports for #{store.name}"
  end
end