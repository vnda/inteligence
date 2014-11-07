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
      create_header(worksheet)
      fill_data(worksheet, store.monthly_reports)
      worksheet.save
      spreedsheed.human_url
    end

    private
    def self.create_header(worksheet)
      worksheet[1,1] = "Período"
      worksheet[1,2] = "Pedidos Confirmados"
      worksheet[1,7] = "Audiência"

      worksheet[2,2] = "Total de pedidos"
      worksheet[2,3] = "Ticket médio"
      worksheet[2,4] = "Faturamento"
      worksheet[2,5] = "Total de itens"
      worksheet[2,6] = "Taxa de Conversão"
      worksheet[2,7] = "Visitas"
      worksheet[2,8] = "Page view"
      worksheet[2,9] = "Usuários Únicos"
    end

    def self.fill_data(worksheet, reports)
      reports.each_with_index do |report, index|
        worksheet[3 + index,1] = report.reference_date.strftime("%m - %Y")
        worksheet[3 + index,2] = report.orders_count
        worksheet[3 + index,3] = report.average_ticket
        worksheet[3 + index,4] = report.orders_yield
        worksheet[3 + index,5] = report.items_count
      end 
    end
  end
end