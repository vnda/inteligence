module Store::Reports::SkuCurve
  
  module InstanceMethods

    def sku_curve_report_for(start_date, end_date)
      itens = self.order_itens(start_date, end_date)
      grouped_result = itens.group_by {|x|x['sku']}

      reports = []
      grouped_result.each do |key, value|
        hash = {}
        hash[:sku] = key
        hash[:properties] = variant_properties_for(key)
        hash[:variant_name] = value.first['variant_name']
        hash[:reference] = value.first['reference']
        hash[:quantity] = value.map{|x| x['quantity']}.reduce(:+) || 0
        hash[:total_price] = value.map{|x| x['price']}.reduce(:+) || 0.0
        hash[:price] = hash[:total_price] / hash[:quantity]
        hash[:name] = value.first['product_name']
        reports << hash
      end

      reports.sort{|x| x[:quantity] }
    end

    def sku_curve_report(start_date, end_date, email)
      report = abc_curve_reports.find_by(start: start_date, end: end_date)
      return report.drive_url if report
      reports = abc_curve_report_for(start_date, end_date, email)
      drive_url = VndaAPI::Drive.create_abc_curve_report_spreedsheet(self, reports, start_date, end_date)
      abc_curve_reports.create(start: start_date, end: end_date, drive_url: drive_url)
      drive_url
    end

    def variant_properties_for(sku)
      api = VndaAPI::Variants.new(api_url,user,password)
      variant = api.variant_info(sku)
      variant['properties'] ? variant['properties'].select {|k,v| JSON.parse(v)['defining'] } : []
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end