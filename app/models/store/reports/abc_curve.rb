load 'lib/vnda_api/orders.rb'

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
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end