load 'lib/vnda_api/google_drive.rb'

class Api::V1::StoreController < ActionController::Base

  def monthly_report
    store = Store.find(params[:store_id])
    store.update_orders

    render json: {spreedsheet_url: VndaAPI::Drive.create_monthly_report_spreedsheet(store)}
  end

end
