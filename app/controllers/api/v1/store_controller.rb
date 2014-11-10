load 'lib/vnda_api/google_drive.rb'

class Api::V1::StoreController < ActionController::Base

  def monthly_report
    store = Store.find(params[:store_id])
    store.load_orders!
    store.process_monthly_report

    render json: {spreedsheet_url: VndaAPI::Drive.create_monthly_report_spreedsheet(store)}
  end

  def state_report
    store = Store.find(params[:store_id])
    store.load_orders!
    store.process_state_report

    render json: {spreedsheet_url: VndaAPI::Drive.create_state_report_spreedsheet(store)}
  end

end
