class Api::V1::MonthliesController < ApplicationController

  def show
    begin
      render json: {spreedsheet_url: store.monthly_report(start_date, end_date, email)}
    rescue ArgumentError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue TypeError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue ActiveRecord::RecordNotFound
      render status: :forbidden, json: { error: 'Invalid token' }
    end
  end
end
