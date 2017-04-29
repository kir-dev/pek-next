Rails.application.routes.draw do

  get '/logout', to: 'sessions#destroy', as: :logout
  get '/login', to: 'sessions#new', as: :login
  get '/auth/oauth/callback', to: 'sessions#create'
  get '/register', to: 'registration#new'
  post '/register/create', to: 'registration#create', as: :registration
  resources :photos, only: [:show, :update, :edit]
  get '/profiles/me/', to: 'profiles#show_self'
  resources :profiles, only: [:show, :update, :edit]

  get '/photo/raw', to: 'raw_photos#show'
  post '/photo/raw', to: 'raw_photos#update'

  get '/search', to: 'search#search'
  get '/search/suggest', to: 'search#suggest'

  root to: redirect('/profiles/me')

end
