require 'httparty'
require 'pp'
require 'uri'

module VndaAPI
  class Variants
    include HTTParty
    format :json

    def initialize(base_uri, user, password)
      @base_uri = base_uri
      @auth = {username: user, password: password}
    end

    def variant_info(sku)
      get("http://#{@base_uri}/api/v2/variants/#{sku}")
    end

    private
    def get(url)
      JSON.parse(self.class.get(URI.escape(url), {basic_auth: @auth}).body)
    end
  end
end