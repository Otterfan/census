Rails.application.routes.draw do
  get 'robots/show'

  devise_for :users

  namespace :admin do
    get 'home/index'

    get 'texts/:census_id', to: 'texts#edit', constraints: {census_id: /\d\.\d+-?\d+/}
    get 'texts/:census_id/edit', to: 'texts#edit', constraints: {census_id: /\d\.\d+-?\d+/}
    get 'public/texts/:census_id', to: 'public/texts#show', constraints: {census_id: /\d\.\d+-?\d+/}
    get 'public/privacy', to: 'public/pages#privacy'

    resources :versions, :path => 'changes', :only => [:index, :show]
    resources :comments
    resources :volumes
    resources :journals
    resources :places
    resources :roles
    resources :texts, :id => /[^\/]+/ do
      resources :components
      post 'original', on: :member, to: 'texts#update_original'
    end
    resources :standard_identifiers
    resources :people, :path => 'authors'

    root :to => 'home#index'
  end

  root to: 'pages#index'

  # Error routes
  get '/404', to: 'public/errors#not_found'
  get '/422', to: 'public/errors#unacceptable'
  get '/500', to: 'public/errors#internal_error'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Blazer::Engine, at: "reports"

  namespace :public do
    get 'pages/privacy'

    root :to => "search#search"
    resources :search, :only => [:index], to: "search#search"
    # get "search", to: "search#search"
    get 'recent-searches', to: "recent_search#index"
    get 'texts/:id', to: 'texts#show'

    resources :texts, :only => [:index, :show]
    resources :volumes, :only => [:index, :show]
    resources :journals, :only => [:index, :show]
    resources :authors, :only => [:index, :show]
    resources :controlled_name, :only => [:index, :show], :id => /.*/, :path => 'people'

    get 'authors/letter(/:first_letter)', to: 'authors#letter'
    get 'journals/letter(/:first_letter)', to: 'journals#letter'
    get 'volumes/letter(/:first_letter)', to: 'volumes#letter'

    get '/authors/(:id)/profile', to: 'authors#profile'
    get '/authors/(:id)/(:genre)/(:medium)', to: 'authors#show_by_type'

  end
end