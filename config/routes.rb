Rails.application.routes.draw do
  
  root 'books#index'

  # Auth routes scope

  devise_for :users 

  # Book routes scope
  
  resources :books, except: [:show] do
    
    # Book notes routes scope

    resources :notes
  
  end

end
