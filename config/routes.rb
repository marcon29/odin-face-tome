Rails.application.routes.draw do
  
  # uses letter_opener gem to test email sending without sending emails
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  
  
  resources :posts


  

  devise_for :users, controllers: {registrations: "registrations", omniauth_callbacks: "omniauth_callbacks"}
  
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

  # resources :friends do
  #   collection do
  #     get "requests"
  #   end
  # end
  
  get 'about', to: 'static#about'

  # change to this once built
  # root 'posts#index'
  root 'static#about'
  
end
