Rails.application.routes.draw do
  
  devise_for :users

  resources :products, only: [:index]
  root to: 'home#index'

end
