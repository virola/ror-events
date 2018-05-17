Rails.application.routes.draw do
  # resources :events
  resources :members, shallow: true do
    resources :events
  end

  # API for clients
  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy]
      resources :members, only: [:index, :create, :show, :update, :destroy]
      resources :events, only: [:index, :create, :show, :update, :destroy]
      
      post 'session/login', to: 'sessions#wx_login'
      post 'session/check', to: 'sessions#check'
      get 'index/events', to: 'index#events'
      get 'index/count', to: 'index#count'
      get 'index/mine', to: 'index#mine'
    end
  end
  # API for clients END
  get 'members/:id/password', to: 'members#admin_password', as: 'password_member'

  resources :sessions, only: [:new, :create, :destroy]
  # post 'sessions/login_open_id', to: 'sessions#login_open_id'
  # get 'sessions/get_session_key', to: 'sessions#get_session_key'
  
  get 'profile', to: 'members#profile'
  get 'profile/edit', to: 'members#edit_info'
  get 'profile/password', to: 'members#edit_password'
  patch 'profile/update', to: 'members#update_info'
  put 'profile/update', to: 'members#update_info'
  patch 'profile/password_update', to: 'members#update_password'
  put 'profile/password_update', to: 'members#update_password'

  get 'admin/events', to: 'events#all'
  get 'index/events', to: 'index#events'
  get 'index/count', to: 'index#count'

  # admin
  get 'admin', to: 'admin#index'

  root :to => "index#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
