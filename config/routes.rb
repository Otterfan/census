Rails.application.routes.draw do
  get 'robots/show'
  get 'texts/:id', to: 'texts#edit', constraints: { id: /\d\.\d+/ }

  resources :versions, :path => '/changes', :only => [:index, :show]
  resources :comments
  resources :volumes
  resources :journals
  resources :places
  devise_for :users
  root to: 'pages#index'
  resources :roles
  resources :texts, :id => /[^\/]+/  do
    resources :components
    post 'original', on: :member, to: 'texts#update_original'
  end
  resources :standard_identifiers
  resources :people, :path => 'authors'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Blazer::Engine, at: "reports"

  namespace :public do
    root :to => "search#search"
    resources :search, :only => [:index], to: "search#search"
    # get "search", to: "search#search"
    get 'recent-searches', to: "recent_search#index"
    get 'texts/:id', to: 'texts#show', constraints: { id: /\d\.\d+/ }

    resources :texts, :only => [:index, :show]
    resources :volumes, :only => [:index, :show]
    resources :journals, :only => [:index, :show]
    resources :authors, :only => [:index, :show]
    resources :controlled_name, :only => [:index, :show], :id => /.*/, :path => 'people'

    get 'authors/letter(/:first_letter)', to: 'authors#letter'
    get 'journals/letter(/:first_letter)', to: 'journals#letter'

  end
end