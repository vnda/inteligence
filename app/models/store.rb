class Store < ActiveRecord::Base
  include Store::Reports::AbcCurve
  include Store::Reports::Monthly
  include Store::Reports::State
  include Store::OrderLoader

  before_create :generate_token

  has_many :monthly_reports
  has_many :state_reports
  has_many :abc_curve_reports

  validates :name, :api_url, :user, :password, presence: true

  def update_daily_reports
    beginning_of_day = DateTime.now.beginning_of_day - 1.day
    end_of_day = DateTime.now.end_of_day - 1.day
    update_reports_for(start_date, end_date, "daily")
    clear_old_reports_for(beginning_of_day - 31.days, "daily")
  end

  def update_weekly_reports
    beginning_of_week = DateTime.now.beginning_of_week - 1.week
    end_of_week = DateTime.now.end_of_week - 1.week
    update_reports_for(start_date, end_date, "weekly")
    clear_old_reports_for(beginning_of_day - 32.weeks, "weekly")
  end

  def update_monthly_reports
    beginning_of_month = DateTime.now.beginning_of_month - 1.month
    end_of_month = DateTime.now.end_of_month - 1.month
    update_reports_for(start_date, end_date, "monthly")
    clear_old_reports_for(beginning_of_day - 12.months, "monthly")
  end

  def update_full_daily_reports
    beginning_of_day = DateTime.now.beginning_of_day - 1.day
    end_of_day = DateTime.now.end_of_day - 1.day
    31.times do |i|
      start_date = beginning_of_day - i.day
      end_date = end_of_day - i.day
      update_reports_for(start_date, end_date, "daily")
    end
  end

  def update_full_weekly_reports
    beginning_of_week = DateTime.now.beginning_of_week - 1.week
    end_of_week = DateTime.now.end_of_week - 1.week
    32.times do |i|
      start_date = beginning_of_week - i.week
      end_date = end_of_week - i.week
      update_reports_for(start_date, end_date, "weekly")
    end
  end

  def update_full_monthly_reports
    beginning_of_month = DateTime.now.beginning_of_month - 1.month
    end_of_month = DateTime.now.end_of_month - 1.month
    12.times do |i|
      start_date = beginning_of_month - i.month
      end_date = end_of_month - i.month
      update_reports_for(start_date, end_date, "monthly")
    end
  end

  private

  def update_reports_for(start_date, end_date, date_type)
    sales_report = monthly_report_for(start_date, end_date)

    self.monthly_reports << MonthlyReport.new(start: start_date, end: end_date, payload: sales_report.to_json, date_type: date_type)
    abc_curve = abc_curve_report_for(start_date, end_date)
    self.abc_curve_reports << AbcCurveReport.new(start: start_date, end: end_date, payload: abc_curve.to_json, date_type: date_type)
    state = state_report_for(start_date, end_date)
    self.state_reports << StateReport.new(start: start_date, end: end_date, payload: state.to_json, date_type: date_type)
  end

  def clear_old_reports_for(old_date, date_type)
    self.monthly_reports.where("monthly_reports.end < ? AND monthly_reports.date_type = ?", old_date, date_type).destroy_all
    self.abc_curve_reports.where("abc_curve_reports.end < ? AND abc_curve_reports.date_type = ?", old_date, date_type).destroy_all
    self.state_reports.where("state_reports.end < ? AND state_reports.date_type = ?", old_date, date_type).destroy_all
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
