class WeeklyUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly }

  def perform
    Store.all.each {|s| StoreUpdateWeeklyReportsWorker.perform_async(s.id) }
  end
end