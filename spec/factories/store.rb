FactoryGirl.define do
  factory :test_store, class: Store do
    name 'budhakherhi'
    api_url 'budhakherhi.vnda.com.br'
    user 'd62a57d1c28bc16976b20fde27a1df29'
    password 'a5677c0983177b562913498495eed0c3'
  end
end

# Store.new(name: 'budhakherhi', api_url: 'budhakherhi.vnda.com.br', user: 'd62a57d1c28bc16976b20fde27a1df29', password: 'a5677c0983177b562913498495eed0c3').save
# Store.new(name: 'bodystore', api_url: 'bodystore.vnda.com.br', user: '687bd25d54f49b9aa484', password: '55428634a0bba0b90c58', ga_token: 'Aeb3U7maQKoZaidXmerc_w').save

