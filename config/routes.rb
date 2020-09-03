Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  get 'products/search', to: 'products#search'
  resources :products do
    resources :orders, only: [:show, :new, :create]
  
    resources :questions, only: [:new, :create] do
      resources :answers, only: [:new, :create]
    end
  end

  resources :users, only: [:show]
end