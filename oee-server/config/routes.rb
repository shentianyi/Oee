Rails.application.routes.draw do

  post 'users', to: 'users#create'
  devise_for :users, controllers: {sessions: 'users/sessions'}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout'}

  resources :users

  root to: "welcome#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
