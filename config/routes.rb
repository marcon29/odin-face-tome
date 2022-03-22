Rails.application.routes.draw do
  # uses letter_opener gem to test email sending without sending emails
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  root 'posts#index'  
  
  resources :likes, only: [:create, :destroy] 
  resources :comments, only: [:create, :edit, :update, :destroy] 
  resources :posts, only: [:index, :show, :create, :edit, :update, :destroy]

  devise_for :users, controllers: {
    registrations: "registrations", 
    sessions: "sessions", 
    omniauth_callbacks: "omniauth_callbacks"
  }
  
  resources :users, only: [:index, :show] do
    member do
      get :edit_profile_image
      patch :update_profile_image
      delete :delete_profile_image
    end
  end 
  
  resources :friends, only: [:index, :create, :update, :destroy] do
    collection do
      get "requests"
    end
  end

  get 'about', to: 'static#about'
end
