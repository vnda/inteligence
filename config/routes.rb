require 'sidekiq/web'

Rails.application.routes.draw do
  root 'stores#index'
  resources :status, only: [:index]
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :api, :defaults => { :format => 'json' }  do
    namespace :v1 do
      resource :monthly, only: [:show]
      resource :state, only: [:show]
      resource :abc_curve, only: [:show]
    end
  end
  resources :sales, only: [:index] 
  resources :stores
end
