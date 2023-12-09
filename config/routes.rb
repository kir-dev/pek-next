Rails.application.routes.draw do

  get '/logout', to: 'sessions#destroy', as: :logout
  get '/login', to: 'sessions#new', as: :login
  get '/auth/oauth/callback', to: 'sessions#create'
  get '/register', to: 'registration#new'
  post '/register/create', to: 'registration#create', as: :registration
  resources :photos, only: [:show, :update, :edit], constraints: { id: /[^\/]+/ }
  get '/profiles/me/', to: 'profiles#show_self'
  resources :profiles, only: [:show, :update, :edit], constraints: { id: /[^\/]+/ }
  post '/profiles/:id/view-settings', to: 'profiles#update_view_setting', constraints: { id: /[^\/]+/ }, as: :update_view_setting
  patch '/profiles/:id/view-settings', to: 'profiles#update_view_setting', constraints: { id: /[^\/]+/ }
  # These are for linking vir urls
  get '/profile/show/uid/:id', to: redirect('/profiles/%{id}'), constraints: { id: /[^\/]+/ }
  get '/profile/show/virid/:id', to: 'profiles#show_by_id', constraints: { id: /\d+/ }

  get '/photo/raw', to: 'raw_photos#show'
  post '/photo/raw', to: 'raw_photos#update'

  get '/search', to: 'search#search'
  get '/search/suggest', to: 'search#suggest'
  get '/search/suggest_leader', to: 'search#suggest_leader'

  get '/svie/edit', to: 'svie#edit'
  post '/svie/update', to: 'svie#update'
  post '/svie/destroy', to: 'svie#destroy'
  post '/svie/outside', to: 'svie#outside'
  post '/svie/inside', to: 'svie#inside'
  resources :svie, only: %i[index new create]
  get '/svie/pdf', to: 'svie#application_pdf'
  get '/svie/hierarchy', to: 'svie#hierarchy'

  get '/judgement', to: 'judgements#index', as: :judgements
  get '/judgement/:evaluation_id', to: 'judgements#show', as: :judgement
  post '/judgement/:evaluation_id/update', to: 'judgements#update', as: :update_judgement

  root to: redirect('/profiles/me')
  get 'groups/all', to: 'groups#all', as: :all_groups
  resources :groups, only: [:show, :index, :edit, :update, :create, :new] do
    resources :sub_groups do
      post :join, on: :member
      delete :leave, on: :member
      post :set_admin, on: :member
      resources :sub_group_principles, as: :principles ,only: [:index, :update, :create, :destroy]
      resources :sub_group_evaluations, as: :evaluation do
        get :table
      end
    end
    resources :memberships, only: [:create, :destroy] do
      post '/inactivate', to: 'memberships#inactivate'
      post '/reactivate', to: 'memberships#reactivate'
      post '/accept', to: 'memberships#accept'
      post :withdraw, on: :member
      put '/archive', to: 'memberships#archive'
      put '/unarchive', to: 'memberships#unarchive'
      resources :posts, only: [:index, :create, :destroy]
    end

    get '/group_posts', to: "posts#group_posts", as: :posts
    resources :post_types, only: [:index, :create, :destroy]

    get '/evaluations/current', to: 'evaluations#current'
    resources :evaluations, only: [:show, :edit, :update] do
      resources :principles, only: [:index, :update, :create, :destroy]
      post '/pointdetails/update', to: 'point_details#update'
      resources :point_detail_comments, shallow: true, only: %i[index create update edit]
      post '/entryrequests', to: 'evaluations#submit_entry_request'
      delete '/entryrequests', to: 'evaluations#cancel_entry_request', as: :cancel_entry_request
      post '/entryrequests/update', to: 'entry_requests#update'
      get '/justifications/edit', to: 'justifications#edit'
      post '/justifications/update', to: 'justifications#update'
      get '/table', to: 'evaluations#table'
      post '/pointrequest', to: 'evaluations#submit_point_request'
      delete '/pointrequest', to: 'evaluations#cancel_point_request', as: :cancel_point_request
      post :copy_previous_principles
    end
    get '/messages', to: 'messages#index'
    get '/messages/all', to: 'messages#all'
    post '/messages', to: 'messages#create'
    get '/delegates', to: 'delegates#show'
    post '/delegate', to: 'delegates#create'
    delete '/delegate', to: 'delegates#destroy'
    get '/history', to: 'group_history#show'
  end
  resources :sub_group_memberships, only: :destroy

  get '/korok/showgroup/id/:id', to: redirect('/groups/%{id}')

  post '/privacies/update', to: 'privacies#update'

  resources :im_accounts, only: [:create, :update, :destroy]

  namespace :admin do
    get 'delegates/count', to: 'delegates#count'
    get 'delegates/export', to: 'delegates#export'
    get 'delegates', to: 'delegates#index'
    post 'delegates/update', to: 'delegates#update'

    resources :svie, only: [:index]
    post '/svie/approve/:id', to: 'svie#approve', as: :svie_approve
    post '/svie/reject/:id', to: 'svie#reject', as: :svie_reject

    resources :rvt_helpers, only: [:index] do
      post :add, on: :member
      post :remove, on: :member
    end
  end

  get '/seasons', to: 'season_admin#index', as: :seasons
  post '/seasons/next', to: 'season_admin#next', as: :next_semester
  post '/seasons/previous', to: 'season_admin#previous', as: :previous_semester
  post '/seasons', to: 'season_admin#update'

  if Rails.env.development? || Rails.env.staging?
    get '/development', to: 'development#index'
    post '/development/impersonate/random', to: 'development#impersonate_someone', as: :impersonate_someone
    post '/development/impersonate/user', to: 'development#impersonate_user', as: :impersonate_user
    post '/development/impersonate/role', to: 'development#impersonate_role', as: :impersonate_role
  end

  get '/services/sync/:id', to: 'auth_sch_services#sync'
  get '/services/sync/:id/memberships', to: 'auth_sch_services#memberships'
  get '/services/entrants/get/:semester/:id', to: 'auth_sch_services#entrants'
  get '/services/entrants/get/:semester/authsch/:id', to: 'auth_sch_services#entrants'

  notify_to :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

end
