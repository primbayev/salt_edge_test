Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :connection, only: :index

  # Defines the root path route ("/")
  root 'connections#index'
end
