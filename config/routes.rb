Rails.application.routes.draw do
  resources :versions, :path => '/changes', :only => [:index, :show]
  resources :comments
  resources :volumes
  resources :journals
  resources :places
  devise_for :users
  root to: 'pages#index'
  resources :roles
  resources :texts do
    resources :components
    post 'original', on: :member, to: 'texts#update_original'
  end
  resources :standard_identifiers
  resources :people, :path => 'authors'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :public do
    root :to => "search#search"
    # resources :search, :only => [:index, :search]
    get "search", to: "search#search"
    resources :texts, :only => [:index, :show]
    resources :volumes, :only => [:index, :show]
  end
end