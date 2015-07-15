require "rubygems"
require "google/api_client"
require "google_drive"

module VndaAPI
  class Drive

    def self.create_session
      c = Google::APIClient.new(application_name: Rails.application.engine_name)
      key = OpenSSL::PKey::RSA.new ENV["GOOGLE_API_P12"], 'notasecret'

      c.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        audience: 'https://accounts.google.com/o/oauth2/token',
        scope: "https://www.googleapis.com/auth/drive " +
          "https://docs.google.com/feeds/ " +
          "https://docs.googleusercontent.com/ " +
          "https://spreadsheets.google.com/feeds/",
        issuer: ENV['GOOGLE_API_ACCOUNT_EMAIL'],
        email: "insights@vnda.com.br",
        signing_key: key
      )

      access_token = c.authorization.fetch_access_token!['access_token']
      GoogleDrive.login_with_oauth(access_token)
    end

    def self.create_monthly_report_spreedsheet(store, reports, start_date, end_date, email)
      session = create_session
      spreedsheed = session.create_spreadsheet(spreedsheet_name(store.name, "Relatório mês a mês", start_date, end_date))
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      spreedsheed.acl.push({:scope_type => "user", :scope => email, :role => "reader"}) unless email.empty?
      worksheet = spreedsheed.worksheets[0]
      worksheet.max_rows = reports.count + 2
      worksheet.max_cols = 9
      create_header(worksheet, "Período")
      fill_monthly_data(worksheet, reports)
      worksheet.save
      spreedsheed.human_url
    end

    def self.create_state_report_spreedsheet(store, reports, start_date, end_date, email)
      session = create_session
      spreedsheed = session.create_spreadsheet(spreedsheet_name(store.name, "Relatório por estado", start_date, end_date))
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      spreedsheed.acl.push({:scope_type => "user", :scope => email, :role => "reader"}) unless email.empty?
      worksheet = spreedsheed.worksheets[0]
      worksheet.max_rows = reports.count + 2
      worksheet.max_cols = 9
      create_header(worksheet, "Estado")
      fill_state_data(worksheet, reports)
      worksheet.save
      spreedsheed.human_url
    end

    def self.create_abc_curve_report_spreedsheet(store, reports, start_date, end_date, email)
      session = create_session
      spreedsheed = session.create_spreadsheet(spreedsheet_name(store.name, "Curva ABC de produtos vendidos", start_date, end_date))
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      spreedsheed.acl.push({:scope_type => "user", :scope => email, :role => "reader"}) unless email.empty?
      worksheet = spreedsheed.worksheets[0]
      worksheet.max_rows = reports.count + 1
      worksheet.max_cols = 5
      create_abc_curve_header(worksheet)
      fill_abc_curve_data(worksheet, reports)
      worksheet.save
      spreedsheed.human_url
    end

    def self.create_sku_curve_report_spreedsheet(store, reports, start_date, end_date, email)
      session = create_session
      spreedsheed = session.create_spreadsheet(spreedsheet_name(store.name, "Curva ABC de variantes vendidos", start_date, end_date))
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      spreedsheed.acl.push({:scope_type => "user", :scope => email, :role => "reader"}) unless email.empty?
      worksheet = spreedsheed.worksheets[0]
      worksheet.max_rows = reports.count + 1
      keys = sku_keys(reports.first, 'name')
      worksheet.max_cols = 7 + keys.size
      create_sku_curve_header(worksheet, keys)
      fill_sku_curve_data(worksheet, reports)
      worksheet.save
      spreedsheed.human_url
    end


    private

    def self.sku_keys(report, chave)
      keys = []
      report[:properties].each do |_, value|
        keys << JSON.parse(value)[chave]
      end
      keys
    end

    def self.create_abc_curve_header(worksheet)
      worksheet[1,1] = "Referência"
      worksheet[1,2] = "Nome"
      worksheet[1,3] = "Quantidade"
      worksheet[1,4] = "Preço"
      worksheet[1,5] = "Valor total"
    end

    def self.create_sku_curve_header(worksheet, keys)
      worksheet[1,1] = "SKU"
      worksheet[1,2] = "Nome da variante"
      keys.each_with_index do |x, index|
        worksheet[1,index + 3] = x
      end 
      worksheet[1,3 + keys.size] = "Referência"
      worksheet[1,4 + keys.size] = "Nome"
      worksheet[1,5 + keys.size] = "Quantidade"
      worksheet[1,6 + keys.size] = "Preço"
      worksheet[1,7 + keys.size] = "Valor total"
    end

    def self.create_header(worksheet, head)
      worksheet[1,1] = head
      worksheet[1,2] = "Pedidos Confirmados"
      worksheet[1,7] = "Audiência"

      worksheet[2,2] = "Total de pedidos"
      worksheet[2,3] = "Ticket médio"
      worksheet[2,4] = "Faturamento"
      worksheet[2,5] = "Média de itens por pedido"
      worksheet[2,6] = "Taxa de Conversão"
      worksheet[2,7] = "Visitas"
      worksheet[2,8] = "Page view"
      worksheet[2,9] = "Usuários Únicos"
    end

    def self.fill_abc_curve_data(worksheet, reports)
      reports.sort_by{|x| x[:quantity]}.reverse!.each_with_index do |report, index|
        worksheet[2 + index,1] = "'"+report[:reference]
        worksheet[2 + index,2] = report[:variant_name]

        worksheet[2 + index,3] = report[:quantity]
        worksheet[2 + index,4] = "R$ " + report[:price].round(2).to_s
        worksheet[2 + index,5] = "R$ " + report[:total_price].round(2).to_s
      end
    end

    def self.fill_sku_curve_data(worksheet, reports)
      reports.sort_by{|x| x[:quantity]}.reverse!.each_with_index do |report, index|
        worksheet[2 + index,1] = "'"+report[:sku]
        worksheet[2 + index,2] = report[:variant_name]

        values = sku_keys(report, 'value')
        values.each_with_index do |x, internal_index|
          worksheet[2 + index,internal_index + 3] = x
        end 

        worksheet[2 + index,3 + values.size] = "'"+report[:reference]
        worksheet[2 + index,4 + values.size] = report[:name]
        worksheet[2 + index,5 + values.size] = report[:quantity]
        worksheet[2 + index,6 + values.size] = "R$ " + report[:price].round(2).to_s
        worksheet[2 + index,7 + values.size] = "R$ " + report[:total_price].round(2).to_s
      end
    end

    def self.fill_state_data(worksheet, reports)
      reports.keys.each_with_index do |key, index|
        worksheet[3 + index,1] = key
        fill_line(worksheet, index, reports[key])
      end 
    end

    def self.fill_monthly_data(worksheet, reports)
      reports.each_with_index do |report, index|
        worksheet[3 + index,1] = "'"+report[:reference_date]
        fill_line(worksheet, index, report)
      end 
    end

    def self.fill_line(worksheet, index, value)
      worksheet[3 + index,2] = value[:orders_count]
      worksheet[3 + index,3] = "R$ " + value[:average_ticket].round(2).to_s
      worksheet[3 + index,4] = "R$ " + value[:orders_yield].round(2).to_s
      worksheet[3 + index,5] = value[:average_itens].round(2)
      worksheet[3 + index,6] = "#{value[:conversion_tax].round(4)}%"
      worksheet[3 + index,7] = value[:visits]
      worksheet[3 + index,8] = value[:pageviews]
      worksheet[3 + index,9] = value[:unique_users]
    end

    def self.spreedsheet_name(store_name, name, start_date, end_date)
      "#{store_name} - #{name} - #{start_date.strftime("%d/%m/%Y")} à #{end_date.strftime("%d/%m/%Y")}"
    end
  end
end