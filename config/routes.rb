require "sidekiq/web"

Rails.application.routes.draw do

  get "/auth/:provider/callback" => "authentications#create"

  devise_for :users
  resources :authentications
  resources :devices
  resources :orders, only: [:index, :new]

  get 'admin' => 'control_panel#index', :as => :admin
  resource :control_panel, only: [:index, :new, :create, :destroy]

  get 'test' => 'test#index'

  root 'control_panel#index'

  mount Sidekiq::Web, at: '/sidekiq'

  scope module: 'webhooks' do
    controller :main do
      post 'webhooks/test' => :test
    end
    controller :clover do
      post 'webhooks/clover' => :receive
      get 'webhooks/clover/test' => :test
    end
    controller :square do
      get 'webhooks/square/test' => :test
    end
  end

end
