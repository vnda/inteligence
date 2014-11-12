load 'lib/vnda_api/orders.rb'
load 'lib/vnda_api/ga_integration.rb'

module Store::Reports::State
  
  module InstanceMethods

    def state_report_for(start_date, end_date)
      results = initial_report
      process_api_data(results, start_date, end_date)
      process_ga_data(results, start_date, end_date)
      
      ga_visits = VndaAPI::GaIntegration.new(self.ga_token, start_date, end_date).state_visits
      unless ga_visits
        ga_visits = ga_visits.group_by {|x| StateMapper.state_for(x['reference_state'])}
        results.merge(ga_visits) {|key, results, visits| results.merge(visits) }
      end
      results
    end

    def process_api_data(results, start_date, end_date)
      grouped_result = self.orders(start_date, end_date).group_by {|x| StateMapper.state_for(x[:reference_state])}
      grouped_result.each do |key, value|
        results[key][:orders_yield] = value.map{|x| x[:total] }.reduce(:+)
        results[key][:orders_count] = value.count
        results[key][:average_itens] = value.map{|x| x[:itens_count] }.reduce(:+) / results[key][:orders_count]
        results[key][:average_ticket] = (results[key][:orders_yield]/results[key][:orders_count])
      end
      results
    end

    def process_ga_data(results, start_date, end_date)
      ga_visits = VndaAPI::GaIntegration.new(self.ga_token, start_date, end_date).state_visits
      unless ga_visits
        ga_visits = ga_visits.group_by {|x| StateMapper.state_for(x['reference_state'])}
        ga_visits.each do |key, value|
          results[key][:pageviews] = value['pageviews']
          results[key][:visits] = value['sessions']
          results[key][:unique_users] = value['users']
          results[key][:conversion_tax] = conversion_tax(results[key][:orders_count], value['sessions'])
        end
      end
      results
    end

    def initial_report
      {
        'Acre' => state_keys,
        'Alagoas' => state_keys,
        'Amapá' => state_keys,
        'Amazonas' => state_keys,
        'Bahia' => state_keys,
        'Ceará' => state_keys,
        'Distrito Federal' => state_keys,
        'Espírito Santo' => state_keys,
        'Goiás' => state_keys,
        'Maranhão' => state_keys,
        'Mato Grosso' => state_keys,
        'Mato Grosso do Sul' => state_keys,
        'Minas Gerais' => state_keys,
        'Pará' => state_keys,
        'Paraíba' => state_keys,
        'Paraná' => state_keys,
        'Pernambuco' => state_keys,
        'Piauí' => state_keys,
        'Rio de Janeiro' => state_keys,
        'Rio Grande do Norte' => state_keys,
        'Rio Grande do Sul' => state_keys,
        'Rondônia' => state_keys,
        'Roraima' => state_keys,
        'Santa Catarina' => state_keys,
        'São Paulo' => state_keys,
        'Sergipe' => state_keys,
        'Tocantins' => state_keys
      }
    end

    def conversion_tax(orders_count, sessions)
      return 0.0 unless sessions
      orders_count.to_f * 100.0 / sessions.to_f
    end

    def state_keys
      { orders_count: 0, average_ticket: 0.0, orders_yield: 0.0, average_itens: 0.0, conversion_tax: 0.0, visits: 0, pageviews: 0, unique_users: 0}
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end