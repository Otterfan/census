Rails.application.routes.draw do
  resources :roles
  resources :texts do
    resources :components
  end
  resources :standard_identifiers
  resources :people
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
