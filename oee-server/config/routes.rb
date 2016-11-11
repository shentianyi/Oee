Rails.application.routes.draw do


  resources :pam_items do
    collection do
      match :purchase_import, to: :purchase_import, via: [:get, :post]
      match :ts_import, to: :ts_import, via: [:get, :post]
      match :finance_import, to: :finance_import, via: [:get, :post]
    end
  end
  resources :pam_lists
  resources :budget_items
  resources :budgets
  resources :capexes
  resources :user_inventory_tasks
  resources :user_area_items
  resources :areas
  resources :inventory_files
  use_doorkeeper

  resources :inventory_items do
    member do
      get :cover_list
    end
  end
  resources :inventory_lists do
    member do
      get 'inventory_items'

    end

    collection do
      get 'reset_inventory'
      match :import, to: :import, via: [:get, :post]
    end
  end


  resources :asset_balance_items do

  end

  resources :asset_balance_lists do
    member do
      get 'asset_balance_items'
    end
    collection do
      match :import, to: :import, via: [:get, :post]
    end
  end
  resources :fix_asset_tracks do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :equipment_releases do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :equipment_depreciations do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :attachments

  resources :equipment_tracks do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :work_shifts

  resources :downtime_records do
    collection do
      get :search
      match :display, to: :display, via: [:get, :post]
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
  devise_for :users, controllers: {sessions: 'users/sessions'}, path: 'auth', path_names: {sign_in: 'login', sign_out: 'logout'}
  resources :users

  root to: "welcome#index"

  get 'api' => 'home#api', as: 'api'
  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1 do
      resources :users do
        collection do
          post :login
          post :logout
        end
      end

      resources :inventory_lists do
        collection do
          get :inventory_items
          get :generate_file
        end
      end

      resources :areas
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
