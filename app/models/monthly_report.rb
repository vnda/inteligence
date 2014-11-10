class MonthlyReport < ActiveRecord::Base
  belongs_to :store

  def report
    {
      reference_date: reference_date.strftime("%m/%Y"),
      orders_count: orders_count,
      orders_yield: orders_yield,
      average_ticket: average_ticket,
      average_itens: average_itens
    }
  end
end
