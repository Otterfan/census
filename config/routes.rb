Rails.application.routes.draw do
  get 'pages/help'
  get 'page/index'
  get 'robots/show'
  get 'about', to: 'pages#about'
  get 'project-team', to: 'pages#project_team'
  get 'links', to: 'pages#links'
  get 'contact', to: 'pages#contact'
  get 'sponsors', to: 'pages#sponsors'
  get 'future-outlook', to: 'pages#future_outlook'
  get 'in-the-media', to: 'pages#in_the_media'
  get '/help/transliteration', to: 'pages#transliteration'
  get '/help/browsing-and-searching', to: 'pages#browsing_and_searching'
  get '/help/legend', to: 'pages#legend'
  get 'news', to: 'pages#news'
  get '/help/helpful-pointers', to: 'pages#helpful_pointers'

  devise_for :users

  namespace :admin do
    get 'home/index'

    get 'texts/:census_id', to: 'texts#edit', constraints: {census_id: /\d\.\d+-?\d+/}
    get 'texts/:census_id/edit', to: 'texts#edit', constraints: {census_id: /\d\.\d+-?\d+/}

    resources :versions, :path => 'changes', :only => [:index, :show]
    resources :comments
    resources :news
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

  # Error routes
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Blazer::Engine, at: "reports"

  get 'pages/privacy'

  root :to => "pages#index"
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