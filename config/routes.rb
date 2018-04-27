Rails.application.routes.draw do
  # devise_for :members
  # resources :events
  resources :members, shallow: true do
    resources :events
  end
  resources :sessions, only: [:new, :create, :destroy]
  
  get 'profile', to: 'members#profile'
  get 'profile/edit', to: 'members#edit_info'
  get 'profile/password', to: 'members#edit_password'
  patch 'profile/update', to: 'members#update_info'
  put 'profile/update', to: 'members#update_info'
  patch 'profile/password_update', to: 'members#update_password'
  put 'profile/password_update', to: 'members#update_password'

  get 'events', to: 'events#all'
  get 'index/today', to: 'index#index'

  # admin
  get 'admin', to: 'admin#index'

  root :to => "index#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
