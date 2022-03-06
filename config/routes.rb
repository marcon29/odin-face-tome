Rails.application.routes.draw do
  
  resources :users
  
  get 'about', to: 'static#about'

  # change to this once built
  # root 'posts#index'
  root 'static#about'
  
end
