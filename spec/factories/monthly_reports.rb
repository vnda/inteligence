FactoryGirl.define do
  factory :monthly_report do
    reference_date "2014-11-07"
orders_count 1
orders_yield 1
average_ticket 1
store nil
  end

end
