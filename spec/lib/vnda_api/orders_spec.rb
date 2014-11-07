require 'spec_helper'
load 'lib/vnda_api/orders.rb'

describe VndaAPI::Orders do

  let(:test_store) { build(:test_store) }
  let(:orders) { VndaAPI::Orders.new(test_store.api_url, test_store.user, test_store.password, 20) }

  # TODO: need to mock httparty get...
    
  context '#all' do
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/all.json'), :headers => {})
    end
    
    it "retrieve all orders" do
      expect(orders.all.count).to eq(12)
    end
  end

  context '#confirmed' do
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=1&per_page=20&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/items/one.json'), :headers => {})
    end
    
    it "retrieve only confirmed orders" do
      expect(orders.confirmed.count).to eq(1)
    end
  end

      
  context '#shipping_address' do
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/shipping_address").
         to_return(:status => 200, :body => File.new('spec/fixtures/shipping_address/sc.json'), :headers => {})
    end
    
    it "retrieve shipping_address from a specific order" do
      order_code = "B9778A26CD"
      expect(orders.shipping_address(order_code)['state']).to eq('SC')
    end
  end

  context '#items' do
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/items").
         to_return(:status => 200, :body => File.new('spec/fixtures/items/one.json'), :headers => {})
    end

    it "retrieve shipping_address from a specific order" do
      order_code = "B9778A26CD"
      expect(orders.items(order_code).count).to eq(1)
    end
  end
end