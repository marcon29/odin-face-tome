Rails.application.routes.draw do
  
  devise_for :users  
  resources :users, onlt: [:index, :show]
  resources :friends, only: [:index, :new, :create, :destroy]
  
  get 'about', to: 'static#about'

  # change to this once built
  # root 'posts#index'
  root 'static#about'
  
end
