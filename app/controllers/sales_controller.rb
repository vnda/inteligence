class SalesController < ApplicationController
  layout "insights"

  def daily
    @reports = store.monthly_reports.where(date_type: "daily").order(start: :desc)
  end

  def weekly
    @reports = store.monthly_reports.where(date_type: "weekly").order(start: :desc)
  end

  def monthly
    @reports = store.monthly_reports.where(date_type: "monthly").order(start: :desc)
  end
end