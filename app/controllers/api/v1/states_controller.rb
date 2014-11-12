load 'lib/vnda_api/drive.rb'

class Api::V1::StatesController < ApplicationController

  def show
    start_date = Date.parse(params['start'])
    end_date = Date.parse(params['end'])
    reports = store.state_report_for(start_date, end_date)
    render json: {spreedsheet_url: VndaAPI::Drive.create_state_report_spreedsheet(store, reports, start_date, end_date)}
  end
end
