class Api::V1::AbcCurvesController < ApplicationController

  def show
    begin
      render json: {spreedsheet_url: store.abc_curve_report(start_date, end_date)}
    rescue ArgumentError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue TypeError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue ActiveRecord::RecordNotFound
      render status: :forbidden, json: { error: 'Invalid token' }
    end
  end
end
