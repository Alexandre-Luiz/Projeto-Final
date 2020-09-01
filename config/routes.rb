Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  get 'products/search', to: 'products#search'
  resources :products, only: [:index, :show, :new, :create] do
    #get 'question', to: 'products#question'
    resources :questions, only: [:index, :new, :create]
    #resources :questions, on: :collection
  end

  resources :users, only: [:show]

end