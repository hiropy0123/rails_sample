Rails.application.routes.draw do

  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # RESTful resources
  resources :users
  resources :accout_activations, only: [:edit]

  # rootは最後に記述する
  root 'static_pages#home'

end
