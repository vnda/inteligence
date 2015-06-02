class StatesController < ApplicationController
  layout "insights"

  def daily
    @reports = store.state_reports.where(date_type: "daily").order(start: :desc)
    @first_report = @reports.first
  end

  def weekly
    @reports = store.state_reports.where(date_type: "weekly").order(start: :desc)
    @first_report = @reports.first
  end

  def monthly
    @reports = store.state_reports.where(date_type: "monthly").order(start: :desc)
    @first_report = @reports.first
  end
end