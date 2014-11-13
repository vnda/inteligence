require 'httparty'
require 'pp'

module VndaAPI
  class Orders
    include HTTParty
    format :json

    def initialize(base_uri, user, password, page_size = 100)
      @page_size = page_size
      @base_uri = base_uri
      @auth = {username: user, password: password}
    end

    def all
      get("http://#{@base_uri}/api/v2/orders")
    end

    def confirmed(start_date, end_date, page = 1)
      get("http://#{@base_uri}/api/v2/orders?status=confirmed&per_page=#{@page_size}&page=#{page}&start=#{start_date.strftime("%d/%m/%Y")}&end=#{end_date.strftime("%d/%m/%Y")}")
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
      JSON.parse(self.class.get(url, {basic_auth: @auth}).body)
    end
  end
end