load 'lib/vnda_api/orders.rb'

module Store::Report
  
  module InstanceMethods

    def monthly_report
      self.monthly_reports.map(&:report)
    end

    def update_orders
      api = VndaAPI::Orders.new(api_url,user,password)

      last_page = 1
      result = []
      response = api.confirmed(last_page)
      while !response.empty? do
        response.each do |order|
          hash = order.slice("code", "total")
          hash['reference_date'] = Date.parse(order['updated_at'])
          hash['items_count'] = api.items(hash['code']).count
          hash['state'] = api.shipping_address(hash['code'])['state']
          result.append(hash)
        end
        last_page += 1
        response = api.confirmed(last_page)
      end
      process_monthly_report(result)
    end

    def process_monthly_report(result)
      grouped_result = result.group_by {|x|x['reference_date'].strftime("%m/%Y")}
      grouped_result.each do |key, value|
        orders_yield = value.map{|x| x['total']}.reduce(:+).round(2)
        items_count = value.map{|x| x['items_count']}.reduce(:+)
        orders_count = value.count
        average_ticket = (orders_yield/orders_count).round(2)
        monthly_report = self.monthly_reports.find_or_create_by(reference_date: Date.parse(key))
        monthly_report.update(items_count: items_count, orders_count: orders_count, orders_yield: orders_yield, average_ticket: average_ticket)
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end