class Api::V1::AbcCurvesController < ApplicationController

  def show
    begin
      AbcCurveWorker.perform_async(store.id, start_date, end_date, email)
      render json: {success: 'ok'}
    rescue ArgumentError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue TypeError
      render status: :bad_request, json: { error: 'start and end dates are required.' }
    rescue ActiveRecord::RecordNotFound
      render status: :forbidden, json: { error: 'Invalid token' }
    end
  end
end
