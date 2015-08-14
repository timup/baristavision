Rails.application.routes.draw do

  get 'control_panel/index'

  get 'control_panel/new'

  get 'control_panel/create'

  get 'control_panel/destroy'

  get "/auth/:provider/callback" => "authentications#create"
  devise_for :users
  resources :authentications
  root 'test#index'

end
