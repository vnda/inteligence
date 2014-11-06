class Store < ActiveRecord::Base
  validates :name, :api_url, :user, :password, presence: true
end
