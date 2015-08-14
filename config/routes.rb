Rails.application.routes.draw do
  get "/auth/:provider/callback" => "authentications#create"
  devise_for :users
  resources :authentications

  get 'admin' => 'control_panel#index', :as => :admin
  resource :control_panel, only: [:index, :new, :create, :destroy]
  root 'control_panel#index'

end
