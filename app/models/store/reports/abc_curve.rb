module Store::Reports::AbcCurve
  
  module InstanceMethods

    def abc_curve_report_for(start_date, end_date)
      itens = self.order_itens(start_date, end_date)
      grouped_result = itens.group_by {|x|x['reference']}

      reports = []
      grouped_result.each do |key, value|
        hash = {}
        hash[:reference] = key
        hash[:quantity] = value.map{|x| x['quantity']}.reduce(:+) || 0
        hash[:total_price] = value.map{|x| x['price']}.reduce(:+) || 0.0
        hash[:price] = hash[:total_price] / hash[:quantity]
        hash[:name] = value.first['product_name']
        reports << hash
      end
      reports.sort{|x| x[:quantity] }
    end

    def abc_curve_report(start_date, end_date)
      report = abc_curve_reports.find_by(start: start_date, end: end_date)
      return report.drive_url if report
      reports = abc_curve_report_for(start_date, end_date)
      drive_url = VndaAPI::Drive.create_abc_curve_report_spreedsheet(self, reports, start_date, end_date)
      abc_curve_reports.create(start: start_date, end: end_date, drive_url: drive_url)
      drive_url
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end