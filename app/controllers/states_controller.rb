class StatesController < ApplicationController
  layout "insights"

  def daily
    @report = store.state_reports.where(date_type: "daily").order(start: :desc).first
  end

  def weekly
    @report = store.state_reports.where(date_type: "weekly").order(start: :desc).first
  end

  def monthly
    @report = store.state_reports.where(date_type: "monthly").order(start: :desc).first
  end
end