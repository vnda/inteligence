class Api::V1::StoreController < ActionController::Base

  def monthly_report
    store = Store.find(params[:store_id])
    store.update_orders

    render json: store.monthly_reports.to_json(exclude: ['id', 'created_at', 'updated_at'])
  end

end
