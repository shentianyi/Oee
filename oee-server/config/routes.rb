Rails.application.routes.draw do

  resources :work_shifts
  resources :downtime_records do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :downtime_codes do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :downtime_types do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :work_times do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :crafts do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :machines do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :departments
  resources :machine_types
  resources :files

  delete 'holidays', to: 'holidays#destroy'
  resources :holidays do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end


  post 'users', to: 'users#create'
  devise_for :users, controllers: {sessions: 'users/sessions'}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout'}
  resources :users

  root to: "welcome#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
