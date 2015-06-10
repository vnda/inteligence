
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
  resources :stores

  resource :sales do
    member do
      get "monthly"
      get 'weekly'
      get 'daily'
    end
  end

  resource :states do
    member do
      get "monthly"
      get 'weekly'
      get 'daily'
    end
  end

  resource :abc_curve do
    member do
      get "monthly"
      get 'weekly'
      get 'daily'
    end
  end

  resource :sku_curve do
    member do
      get "monthly"
      get 'weekly'
      get 'daily'
    end
  end
end
