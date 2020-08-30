Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  resources :products, only: [:index, :show, :new, :create]

  resources :users, only: [:show]


end
