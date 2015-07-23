class SeedSourcesWorker
  include Sidekiq::Worker

  def perform(id)
    store = Store.find(id)
    beginning_of_day = DateTime.now.beginning_of_day - 1.day
    end_of_day = DateTime.now.end_of_day - 1.day

    start_date, end_date, date_type = beginning_of_day, end_of_day, "daily"
    source = store.source_report_for(start_date, end_date)
    store.source_reports << SourceReport.new(start: start_date, end: end_date, payload: source.to_json, date_type: date_type)
    
    start_date, end_date, date_type = beginning_of_day - 15.days, end_of_day, "weekly"
    source = store.source_report_for(start_date, end_date)
    store.source_reports << SourceReport.new(start: start_date, end: end_date, payload: source.to_json, date_type: date_type)

    start_date, end_date, date_type = beginning_of_day - 30.days, end_of_day, "monthly"
    source = store.source_report_for(start_date, end_date)
    store.source_reports << SourceReport.new(start: start_date, end: end_date, payload: source.to_json, date_type: date_type)
    
    puts "Updated daily reports for #{store.name}"
  end
end

# Store.all.each {|s| SeedSourcesWorker.perform_async(s.id) } 