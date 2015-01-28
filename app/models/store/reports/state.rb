module Store::Reports::State
  
  module InstanceMethods

    def state_report(start_date, end_date, email)
      report = state_reports.find_by(start: start_date, end: end_date)
      return report.drive_url if report
      reports = state_report_for(start_date, end_date)
      drive_url = VndaAPI::Drive.create_state_report_spreedsheet(self, reports, start_date, end_date, email)
      state_reports.create(start: start_date, end: end_date, drive_url: drive_url)
      drive_url
    end

    def state_report_for(start_date, end_date)
      results = initial_report
      process_api_data(results, start_date, end_date)
      process_ga_data(results, start_date, end_date)

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
      if ga_visits
        ga_visits = ga_visits['by_month'].group_by {|x| StateMapper.state_for(x['region'])}
        ga_visits.each do |key, value|
          next if key == '(not set)'
          if results[key] == nil
            puts "key fudida: #{key}"
            puts results.keys
          end
          results[key][:pageviews] = value.first['pageviews']
          results[key][:visits] = value.first['sessions']
          results[key][:unique_users] = value.first['users']
          results[key][:conversion_tax] = conversion_tax(results[key][:orders_count], value.first['sessions'])
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