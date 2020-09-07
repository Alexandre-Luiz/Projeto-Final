Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  get 'products/search', to: 'products#search'
  resources :products do
    resources :orders, only: [:show, :new, :create]
    
    get 'my_products', on: :collection
    get 'my_order', to: 'products#my_order'

    resources :questions, only: [:new, :create] do
      resources :answers, only: [:new, :create]
    end
  end
  
  resources :users, only: [:show]
  
  resources :orders, only: [] do
    post 'accept', on: :member
    post 'decline', on: :member
  end

end