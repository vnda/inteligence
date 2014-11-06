require 'httparty'
require 'pp'

module Vnda
  class Orders
    include HTTParty

    def initialize(base_uri, user, password)
      @base_uri = base_uri
      @auth = {username: user, password: password}
    end

    def all
      get("http://#{@base_uri}/api/v2/orders")
    end

    def confirmed
      get("http://#{@base_uri}/api/v2/orders?status=confirmed")
    end

    def shipping_address(order_code)
      get("http://#{@base_uri}/api/v2/orders/#{order_code}/shipping_address")
    end

    private
    def get(url)
      self.class.get(url, {basic_auth: @auth}).parsed_response
    end
  end
end