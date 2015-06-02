class AbcCurvesController < ApplicationController
  layout "insights"

  def daily
    @reports = store.abc_curve_reports.where(date_type: "daily").order(start: :desc)
    @report = @reports.first
  end

  def weekly
    @reports = store.abc_curve_reports.where(date_type: "weekly").order(start: :desc)
    @report = @reports.first
  end

  def monthly
    @reports = store.abc_curve_reports.where(date_type: "monthly").order(start: :desc)
    @report = @reports.first
  end
end