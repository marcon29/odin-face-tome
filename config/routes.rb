Rails.application.routes.draw do
  
  resources :friends, only: [:index, :new, :create, :destroy]
  resources :users
  
  get 'about', to: 'static#about'

  # change to this once built
  # root 'posts#index'
  root 'static#about'
  
end
