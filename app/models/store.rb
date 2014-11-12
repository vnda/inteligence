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

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
