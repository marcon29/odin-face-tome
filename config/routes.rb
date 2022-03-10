Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  devise_for :users, :controllers => {registrations: "registrations"}
  resources :users, only: [:index, :show]
  resources :friends, only: [:index, :new, :create, :destroy]
  
  get 'about', to: 'static#about'

  # change to this once built
  # root 'posts#index'
  root 'static#about'
  
end
