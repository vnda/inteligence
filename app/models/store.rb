class Store < ActiveRecord::Base
  include Store::Report
  has_many :monthly_reports

  validates :name, :api_url, :user, :password, presence: true
end
