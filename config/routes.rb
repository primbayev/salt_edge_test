require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :connections, only: [:index] do
    resources :accounts, only: [:index] do
      resources :transactions, only: [:index]
    end
  end
  get '/connections/create', to: 'connections#create'
  get '/connections/:connection_id/refresh',
      to: 'connections#refresh',
      as: 'connections_refresh'

  get '/connect_sessions',
      to: 'connect_sessions#external_connect_show',
      as: 'connect_sessions_external_connect_show'

  get '/connect_sessions/reconnect',
      to: 'connect_sessions#reconnect',
      as: 'connect_sessions_reconnect'

  get '/connect_sessions/refresh',
      to: 'connect_sessions#refresh',
      as: 'connect_sessions_refresh'

  # Defines the root path route ("/")
  root 'home#index'
end
