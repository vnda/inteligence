require 'httparty'
require 'pp'

module VndaAPI
  class GaIntegration
    include HTTParty
    format :json

    def initialize(token, start_date, end_date)
      @base_uri = ENV['GA_BASE_URI']
      @token = token
      @start_date = start_date.strftime('%Y-%m-%d')
      @end_date = end_date.strftime('%Y-%m-%d')
    end

    def state_visits
      get("http://#{@base_uri}/state_visits?token=#{@token}&start=#{@start_date}&end=#{@end_date}")
    end

    def monthly_visits
      get("http://#{@base_uri}/monthly_visits?token=#{@token}&start=#{@start_date}&end=#{@end_date}")
    end

    def source_stats
      get("http://#{@base_uri}/source_stats?token=#{@token}&start=#{@start_date}&end=#{@end_date}")
    end

    def international_visits
      get("http://#{@base_uri}/international_visits?token=#{@token}&start=#{@start_date}&end=#{@end_date}")
    end

    private
    def get(url)
      JSON.parse(self.class.get(url).body)
    end
  end
end