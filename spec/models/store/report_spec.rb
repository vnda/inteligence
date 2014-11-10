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
      test_store.load_orders!
      test_store.process_monthly_report
    end

    it "creates monthly reports" do
      expect(test_store.monthly_reports.count).to eq(1)
      expect(test_store.monthly_report).to eq([{:reference_date=>"11/2014", :orders_count=>1, :orders_yield=>265.35, :average_ticket=>265.35, :average_itens=>1}])
    end
  end

  context '10 orders' do

    let(:test_store) { create(:test_store) }
    before(:each) do
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=1&per_page=5&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/five.json'), :headers => {})
      ["B9778A26CD", "B9778A26CE", "B9778A26CF", "B9778A26CG", "B9778A26CH", "B9778A26CI", "B9778A26CJ", "B9778A26CK", "B9778A26CL", "B9778A26CM"].each do |code|
        stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/#{code}/items").
           to_return(:status => 200, :body => File.new('spec/fixtures/items/one.json'), :headers => {})
        stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders/#{code}/shipping_address").
           to_return(:status => 200, :body => File.new('spec/fixtures/shipping_address/sc.json'), :headers => {})
        
      end
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=2&per_page=5&status=confirmed").
         to_return(:status => 200, :body => File.new('spec/fixtures/orders/five2.json'), :headers => {})
      stub_request(:get, "http://d62a57d1c28bc16976b20fde27a1df29:a5677c0983177b562913498495eed0c3@budhakherhi.vnda.com.br/api/v2/orders?page=3&per_page=5&status=confirmed").
         to_return(:status => 200, :body => "[]", :headers => {})
      test_store.load_orders!
      test_store.process_monthly_report
    end

    it "creates monthly reports" do
      expect(test_store.monthly_reports.count).to eq(1)
      expect(test_store.monthly_report).to eq([{:reference_date=>"11/2014", :orders_count=>10, :orders_yield=>2653.5, :average_ticket=>265.35, :average_itens=>1}])
    end
  end
end