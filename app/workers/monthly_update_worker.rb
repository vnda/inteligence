class MonthlyUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { monthly }

  def perform
    Store.all.each {|s| StoreUpdateMonthlyReportsWorker.perform_async(s.id) }
  end
end