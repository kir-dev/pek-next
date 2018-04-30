Rails.application.routes.draw do

  get '/logout', to: 'sessions#destroy', as: :logout
  get '/login', to: 'sessions#new', as: :login
  get '/auth/oauth/callback', to: 'sessions#create'
  get '/register', to: 'registration#new'
  post '/register/create', to: 'registration#create', as: :registration
  resources :photos, only: [:show, :update, :edit], constraints: { id: /[^\/]+/ }
  get '/profiles/me/', to: 'profiles#show_self'
  resources :profiles, only: [:show, :update, :edit], constraints: { id: /[^\/]+/ }

  get '/photo/raw', to: 'raw_photos#show'
  post '/photo/raw', to: 'raw_photos#update'

  get '/search', to: 'search#search'
  get '/search/suggest', to: 'search#suggest'

  get '/svie/edit', to: 'svie#edit'
  post '/svie/update', to: 'svie#update'
  post '/svie/destroy', to: 'svie#destroy'
  post '/svie/outside', to: 'svie#outside'
  post '/svie/inside', to: 'svie#inside'
  resources :svie, only: [:index, :new, :create] # :edit, :update]
  post '/svie/approve/:id', to: 'svie#approve', as: :svie_approve # has need refactor
  post '/svie/reject/:id', to: 'svie#reject', as: :svie_reject # has need refactor
  get '/svie/pdf', to: 'svie#application_pdf'
  get '/svie/successful', to: 'svie#successful_application'

  root to: redirect('/profiles/me')
  resources :groups, only: [:show, :index, :edit, :update] do
    resources :memberships, only: [:create, :destroy] do
      post '/inactivate', to: 'memberships#inactivate'
      post '/reactivate', to: 'memberships#reactivate'
      put '/archive', to: 'memberships#archive'
      put '/unarchive', to: 'memberships#unarchive'
      resources :posts, only: [:index, :create, :destroy]
    end
    resources :post_types, only: [:create]
    get '/delegates', to: 'delegates#show'
    post '/delegate', to: 'delegates#create'
    delete '/delegate', to: 'delegates#destroy'
  end

  post '/privacies/update', to: 'privacies#update'

  resources :delegates, only: [:index]
  get '/delegates/export', to: 'delegates#export'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

end
