require 'httparty'
require 'pp'

module Vnda
  class Orders
    include HTTParty

    def initialize(base_uri, user, password, page_size = 5)
      @page_size = page_size
      @base_uri = base_uri
      @auth = {username: user, password: password}
    end

    def all
      get("http://#{@base_uri}/api/v2/orders")
    end

    def confirmed(page = 1)
      get("http://#{@base_uri}/api/v2/orders?status=confirmed&per_page=#{@page_size}&page=#{page}")
    end

    def shipping_address(order_code)
      get("http://#{@base_uri}/api/v2/orders/#{order_code}/shipping_address")
    end

    def items(order_code)
      get("http://#{@base_uri}/api/v2/orders/#{order_code}/items")
    end

    def page_size
      @page_size
    end


    private
    def get(url)
      JSON.parse(self.class.get(url, {basic_auth: @auth}))
    end
  end
end