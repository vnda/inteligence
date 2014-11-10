load 'lib/vnda_api/orders.rb'

module Store::Report
  
  module InstanceMethods

    def abc_curve_report
      self.abc_curve_reports.order(quantity: :desc).map(&:report)
    end

    def process_abc_curve_report
      grouped_result = self.order_itens.group_by {|x|x['reference']}
      grouped_result.each do |key, value|
        quantity = value.map(&:quantity).reduce(:+)
        total_price = value.map(&:price).reduce(:+)
        price = total_price / quantity
        name = value.first.name
        abc_curve_report = self.abc_curve_reports.find_or_create_by(reference: key)
        abc_curve_report.update(quantity: quantity, total_price: total_price, price: price, name: name)
      end
    end

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

    def state_report
      self.state_reports.map(&:report)
    end

    def process_state_report
      grouped_result = self.orders.group_by {|x|x['reference_state']}
      grouped_result.each do |key, value|
        orders_yield = value.map{|x| x['total'] }.reduce(:+)
        orders_count = value.count
        average_itens = value.map{|x| x.order_items.count }.reduce(:+) / orders_count
        average_ticket = (orders_yield/orders_count)
        state_report = self.state_reports.find_or_create_by(state: key)
        state_report.update(average_itens: average_itens, orders_count: orders_count, orders_yield: orders_yield, average_ticket: average_ticket)
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end