require "rubygems"
require "google/api_client"
require "google_drive"

module VndaAPI
  class Drive

    def self.create_monthly_report_spreedsheet(store)
      session = GoogleDrive.login(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD'])
      spreedsheed = session.create_spreadsheet("#{store.name} - Relatório mês a mês")
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      worksheet = spreedsheed.worksheets[0]
      create_header(worksheet, "Período")
      fill_monthly_data(worksheet, store.monthly_reports)
      worksheet.save
      spreedsheed.human_url
    end

    def self.create_state_report_spreedsheet(store)
      session = GoogleDrive.login(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD'])
      spreedsheed = session.create_spreadsheet("#{store.name} - Relatório por estado")
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      worksheet = spreedsheed.worksheets[0]
      create_header(worksheet, "Estado")
      fill_state_data(worksheet, store.state_reports)
      worksheet.save
      spreedsheed.human_url
    end

    def self.create_abc_curve_report_spreedsheet(store)
      session = GoogleDrive.login(ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD'])
      spreedsheed = session.create_spreadsheet("#{store.name} - Curva ABC de produtos vendidos")
      spreedsheed.acl.push({:scope_type => "default", :with_key => true, :role => "reader"})
      worksheet = spreedsheed.worksheets[0]
      create_abc_curve_header(worksheet)
      fill_abc_curve_data(worksheet, store.abc_curve_reports)
      worksheet.save
      spreedsheed.human_url
    end


    private
    def self.create_abc_curve_header(worksheet)
      worksheet[1,1] = "Referência"
      worksheet[1,2] = "Nome"
      worksheet[1,3] = "Quantidade"
      worksheet[1,4] = "Preço"
      worksheet[1,5] = "Valor total"
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
      reports.each_with_index do |report, index|
        worksheet[2 + index,1] = report.reference
        worksheet[2 + index,2] = report.name
        worksheet[2 + index,3] = report.quantity
        worksheet[2 + index,4] = report.price
        worksheet[2 + index,5] = report.total_price
      end 
    end

    def self.fill_state_data(worksheet, reports)
      reports.each_with_index do |report, index|
        worksheet[3 + index,1] = report.state
        worksheet[3 + index,2] = report.orders_count
        worksheet[3 + index,3] = report.average_ticket
        worksheet[3 + index,4] = report.orders_yield
        worksheet[3 + index,5] = report.average_itens
      end 
    end

    def self.fill_monthly_data(worksheet, reports)
      reports.each_with_index do |report, index|
        worksheet[3 + index,1] = report.reference_date.strftime("%m - %Y")
        worksheet[3 + index,2] = report.orders_count
        worksheet[3 + index,3] = report.average_ticket
        worksheet[3 + index,4] = report.orders_yield
        worksheet[3 + index,5] = report.average_itens
      end 
    end
  end
end