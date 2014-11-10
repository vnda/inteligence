load 'lib/vnda_api/orders.rb'

module Store::Report
  
  module InstanceMethods

    def monthly_report
      self.monthly_reports.map(&:report)
    end

    def process_monthly_report
      grouped_result = self.orders.group_by {|x|x['reference_date'].strftime("%m/%Y")}
      grouped_result.each do |key, value|
        orders_yield = value.map{|x| x['total'] }.reduce(:+)
        orders_count = value.count
        average_itens = value.map{|x| x.order_items.count }.reduce(:+) / orders_count
        average_ticket = (orders_yield/orders_count)
        monthly_report = self.monthly_reports.find_or_create_by(reference_date: Date.parse(key))
        monthly_report.update(average_itens: average_itens, orders_count: orders_count, orders_yield: orders_yield, average_ticket: average_ticket)
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end