Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  get 'products/search', to: 'products#search'
  resources :products, only: [:index, :show, :new, :create]

  resources :users, only: [:show]

end
