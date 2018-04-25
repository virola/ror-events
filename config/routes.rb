Rails.application.routes.draw do
  # devise_for :members
  # resources :events
  resources :members, shallow: true do
    resources :events
  end
  resources :sessions, only: [:new, :create, :destroy]
  
  get 'events', to: 'events#all'
  get 'profile', to: 'members#show'

  # admin
  get 'admin', to: 'admin#index'

  root :to => "index#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
