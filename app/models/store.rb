class Store < ActiveRecord::Base
  include Store::Report
  include Store::OrderLoader

  has_many :monthly_reports
  has_many :state_reports
  has_many :orders

  validates :name, :api_url, :user, :password, presence: true
end
