Rails.application.routes.draw do
  
  root 'books#index'

  # Auth routes scope
  devise_for :users 
  resources :users , path: '' do
    # Resources routes scope
    collection do
      resources :books, except: [:show] do
          resources :notes
      end
    end
  end

end
