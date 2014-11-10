load 'lib/vnda_api/orders.rb'

module Store::OrderLoader
  
  module InstanceMethods

    # TODO: Starts where stopped last time...
    def load_orders!
      api = VndaAPI::Orders.new(api_url,user,password)

      last_page = 1
      result = []
      response = api.confirmed(last_page)
      while !response.empty? do
        response.each do |order|

          hash = order.slice("code", "total")
          hash['reference_date'] = Date.parse(order['updated_at'])
          hash['reference_state'] = api.shipping_address(hash['code'])['state']
          order = Order.find_or_create_by(code: hash['code'])
          order.update(hash)
          load_items(api, hash['code'], order)
          self.orders << order
        end
        last_page += 1
        response = api.confirmed(last_page)
      end
      self.save
    end

    def load_items(api, code, order)
      api_order_items = api.items(code)
      api_order_items.each do |api_order_item| 
        order.order_items << OrderItem.create(name: api_order_item['product_name'], quantity: api_order_item['quantity'], price: api_order_item['price'], reference: api_order_item['reference'])
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end