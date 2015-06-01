class DailyUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Store.all.each {|s| StoreUpdateDailyReportsWorker.perform_async(s.id) }
  end
end