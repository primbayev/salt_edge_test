Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :connections, only: [:index] do
    resources :accounts, only: [:index] do
      resources :transactions, only: [:index]
    end
  end
  get '/connections/create', to: 'connections#create'

  get '/connect_sessions',
      to: 'connect_sessions#external_connect_show',
      as: 'connect_sessions_external_connect_show'

  # Defines the root path route ("/")
  root 'home#index'
end
