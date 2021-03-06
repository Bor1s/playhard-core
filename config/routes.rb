require 'sidekiq/web'
require 'admin_constraint'

PlayhardCore::Application.routes.draw do
  get '/dashboard' => 'game_dashboard#index'

  get '/login' => 'sessions#authorize'
  post '/login' => 'sessions#authorize'
  get '/auth/:provider/callback', to: 'sessions#authorize'
  get '/signout', to: 'sessions#destroy', as: :signout

  #Registrations
  resources :registrations, only: [:new, :create, :destroy]

  resources :games do
    member do
      get :take_part
      delete :unenroll
      delete :remove_player
      get :ics
    end
    resources :comments, except: [:index, :new]
    resources :events, only: [:index]
  end

  resources :users, only: [:index, :show]

  resources :tags do
    collection do
      get 'search/:tag_id' => 'tags#search', as: :search
    end
  end

  resources :events

  namespace :admin do
    resources :games, only: [:index]
    resource :profile, only: [:edit, :update] do
      collection do
        delete :remove_account
        get :accounts
      end
    end
    resources :users
  end

  namespace :master do
    resources :accounts, only: [:index, :update]
    resources :games, only: [:index, :destroy]
    resource :profile, only: [:edit, :update] do
      collection do
        delete :remove_account
        get :accounts
      end
    end
  end

  resources :locations, only: [:index]

  root 'application#welcome'

  get '/about_us' => 'application#about_us'

  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  get '*path', to: 'application#routing_error_handler'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
