Rails.application.routes.draw do
  resources :events
  resources :members
  resources :sessions

  root :to => "index#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
