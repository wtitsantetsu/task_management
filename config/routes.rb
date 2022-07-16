Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  namespace :admin do
    resources :users
  end

  root to: 'tasks#index'
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
