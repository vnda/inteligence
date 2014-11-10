class AbcCurveReport < ActiveRecord::Base
  belongs_to :store

  def report
    {
      reference: reference,
      name: name,
      price: price,
      total_price: total_price,
      quantity: quantity
    }
  end
end
