Rails.application.routes.draw do
  
  # change to this once built
  # root 'posts#index'
  root 'static#about'  

  get 'about', to: 'static#about'
  
end
