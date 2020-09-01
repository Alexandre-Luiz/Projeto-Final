Rails.application.routes.draw do
  
  root to: 'home#index'
  devise_for :users
  
  get 'products/search', to: 'products#search'
  resources :products, only: [:index, :show, :new, :create] do
    #resources :questions, on: :collection
    resources :questions, only: [:new, :create] do
      resources :answers, only: [:new, :create]
    end
  end

  resources :users, only: [:show]

end