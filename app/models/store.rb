class Store < ActiveRecord::Base
  include Store::Report
  include Store::OrderLoader

  has_many :monthly_reports
  has_many :state_reports
  has_many :abc_curve_reports
  has_many :orders

  validates :name, :api_url, :user, :password, presence: true

  def order_itens
    OrderItem.joins(:order).where(orders: {store_id: self.id})
  end
end
