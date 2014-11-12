class Api::V1::MonthliesController < ApplicationController

  def show
    start_date = Date.parse(params['start'])
    end_date = Date.parse(params['end'])
    render json: {spreedsheet_url: store.monthly_report(start_date, end_date)}
  end
end
