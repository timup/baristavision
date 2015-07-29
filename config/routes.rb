Rails.application.routes.draw do

  get "/auth/:provider/callback" => "authentications#create"
  devise_for :users
  resources :authentications
  root 'test#index'

end
