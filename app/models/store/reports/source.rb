module Store::Reports::Source
  
  module InstanceMethods

    def source_report_for(start_date, end_date)
      ga_response = VndaAPI::GaIntegration.new(self.ga_token, start_date, end_date).source_stats || {}
      sources = ga_by_source(ga_response)
      reports = []
      sources.each do |value|
        source_hash = {}
        source_hash[:source_medium] = "#{value['source']} / #{value['medium']}"
        source_hash[:orders_count] = value['transactions'].to_i
        source_hash[:revenue] = value['revenue'].to_f
        source_hash[:average_ticket] = source_hash[:revenue] / source_hash[:orders_count]
        source_hash[:pageviews] = value['pageviews'].to_i || 0
        source_hash[:visits] = value['sessions'].to_i || 0
        source_hash[:unique_users] = value['users'].to_i || 0
        source_hash[:conversion_tax] = conversion_tax(source_hash[:orders_count], source_hash[:visits])
        reports << source_hash
      end
      reports
    end

    def source_report(start_date, end_date, email)
      report = source_reports.find_by(start: start_date, end: end_date)
      return report.drive_url if report
      reports = source_report_for(start_date, end_date)
      drive_url = VndaAPI::Drive.create_source_report_spreedsheet(self, reports, start_date, end_date, email)
      source_reports.create(start: start_date, end: end_date, drive_url: drive_url)
      drive_url
    end

    def ga_by_source(ga_source)
      return {} unless ga_source['by_source_medium']
      ga_source['by_source_medium']
    end

    def conversion_tax(orders_count, sessions)
      return 0.0 unless sessions
      orders_count.to_f * 100.0 / sessions.to_f
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end