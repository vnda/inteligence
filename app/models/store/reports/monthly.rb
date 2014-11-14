module Store::Reports::Monthly
  
  module InstanceMethods

    def monthly_report_for(start_date, end_date)
      grouped_result = self.orders(start_date, end_date).group_by {|x|x[:reference_date].strftime("%m/%Y")}
      reports = []
      ga_visits = VndaAPI::GaIntegration.new(self.ga_token, start_date, end_date).monthly_visits || {}
      grouped_result.each do |key, value|
        ga_by_month = ga_by_month(ga_visits, Date.parse(key))
        monthly_hash = {}
        monthly_hash[:orders_yield] = value.map{|x| x[:total] }.reduce(:+)
        monthly_hash[:orders_count] = value.count
        monthly_hash[:average_itens] = value.map{|x| x[:itens_count] }.reduce(:+).to_f / monthly_hash[:orders_count].to_f
        monthly_hash[:average_ticket] = monthly_hash[:orders_yield] / monthly_hash[:orders_count]
        monthly_hash[:pageviews] = ga_by_month['pageviews'].to_i || 0
        monthly_hash[:visits] = ga_by_month['sessions'].to_i || 0
        monthly_hash[:unique_users] = ga_by_month['users'].to_i || 0
        monthly_hash[:conversion_tax] = conversion_tax(monthly_hash[:orders_count], ga_by_month['sessions'].to_i)
        monthly_hash[:reference_date] =  key
        reports << monthly_hash
      end
      reports
    end

    def monthly_report(start_date, end_date, email)
      report = monthly_reports.find_by(start: start_date, end: end_date)
      return report.drive_url if report
      reports = monthly_report_for(start_date, end_date)
      drive_url = VndaAPI::Drive.create_monthly_report_spreedsheet(self, reports, start_date, end_date, email)
      monthly_reports.create(start: start_date, end: end_date, drive_url: drive_url)
      drive_url
    end

    def ga_by_month(ga_visits, reference_date)
      return {} unless ga_visits['by_month']
      ga_visits['by_month'].each do |value|
        return value if value['year_month'] == reference_date.strftime("%Y%m").to_i
      end
      {}
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