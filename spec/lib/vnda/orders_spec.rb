require 'spec_helper'
load 'lib/vnda/orders.rb'

describe Vnda::Orders do

  let(:test_store) { build(:test_store) }
  let(:orders) { Vnda::Orders.new(test_store.api_url, test_store.user, test_store.password) }

  # TODO: need to mock httparty get...
    
  context '#all' do
    it "retrieve all orders" do
      expect(orders.all.count).to eq(12)
    end
  end

  context '#confirmed' do
    it "retrieve only confirmed orders" do
      expect(orders.confirmed.count).to eq(1)
    end
  end

  context '#shipping_address' do
    it "retrieve shipping_address from a specific order" do
      order_code = "B9778A26CD"
      expect(orders.shipping_address(order_code)['state']).to eq('SC')
    end
  end
end