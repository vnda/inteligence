require 'spec_helper'

describe Store::Report do
  context 'one order' do

    let(:test_store) { create(:test_store) }
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=1&per_page=5&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/one.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/items").
         to_return(:status => 200, :body => File.new('spec/fixtures/items/one.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/shipping_address").
         to_return(:status => 200, :body => File.new('spec/fixtures/shipping_address/sc.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=2&per_page=5&status=confirmed").
         to_return(:status => 200, :body => "[]", :headers => {})
      test_store.update_orders
    end

    it "creates monthly reports" do
      expect(test_store.monthly_reports.count).to eq(1)
      expect(test_store.monthly_report).to eq([{:reference_date=>"11/2014", :orders_count=>1, :orders_yield=>265.35, :average_ticket=>265.35, :items_count=>1}])
    end
  end

  context '10 orders' do

    let(:test_store) { create(:test_store) }
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=1&per_page=5&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/five.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/items").
         to_return(:status => 200, :body => File.new('spec/fixtures/items/one.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/B9778A26CD/shipping_address").
         to_return(:status => 200, :body => File.new('spec/fixtures/shipping_address/sc.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=2&per_page=5&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/five.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=3&per_page=5&status=confirmed").
         to_return(:status => 200, :body => "[]", :headers => {})
      test_store.update_orders
    end

    it "creates monthly reports" do
      expect(test_store.monthly_reports.count).to eq(1)
      expect(test_store.monthly_report).to eq([{:reference_date=>"11/2014", :orders_count=>10, :orders_yield=>2653.5, :average_ticket=>265.35, :items_count=>10}])
    end
  end
end