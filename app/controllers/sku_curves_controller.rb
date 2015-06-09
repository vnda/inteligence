class SkuCurvesController < ApplicationController
  layout "insights"

  def daily
    @report = store.sku_curve_reports.where(date_type: "daily").order(start: :desc).first
  end

  def weekly
    @report = store.sku_curve_reports.where(date_type: "weekly").order(start: :desc).first
  end

  def monthly
    @report = store.sku_curve_reports.where(date_type: "monthly").order(start: :desc).first
  end
end