load 'lib/vnda_api/orders.rb'

module Store::OrderLoader
  
  module InstanceMethods
    def orders(start_date, end_date)
      api = VndaAPI::Orders.new(api_url,user,password)

      last_page = 1
      result = []
      response = api.confirmed(start_date, end_date, last_page)
      while !response.empty? do
        response.each do |order|
          hash = {}
          hash[:code] = order['code']
          hash[:total] = order['total']
          hash[:reference_date] = Date.parse(order['received_at'])
          hash[:reference_state] = api.shipping_address(hash[:code])['state']
          hash[:itens_count] = api.items(hash[:code]).map{|y| y['quantity']}.reduce(:+) || 0
          result << hash
        end
        last_page += 1
        response = api.confirmed(start_date, end_date, last_page)
      end
      result
    end

    def order_itens(start_date, end_date)
      api = VndaAPI::Orders.new(api_url,user,password)

      last_page = 1
      result = []
      response = api.confirmed(start_date, end_date, last_page)
      while !response.empty? do
        response.each do |order|
          result.concat(api.items(order['code']))
        end
        last_page += 1
        response = api.confirmed(start_date, end_date, last_page)
      end
      result
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end