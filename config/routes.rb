Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'
  resources :roles
  resources :texts do
    resources :components
  end
  resources :standard_identifiers
  resources :people, :path => 'authors'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
