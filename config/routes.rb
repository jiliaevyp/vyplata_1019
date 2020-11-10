Rails.application.routes.draw do

  #get 'users/new'

  #get 'persons/profile'

  resources :admins
  resources :levels
  resources :comments
  resources :monds
  resources :personals
  resources :tabels
  resources :welcome
  #resources :users
  resources :session

  #resources :welcome do
  #  resources:real_monat
  #end
  #resources :admins do
    #resources  :levels
  #end

  #resources :personals do
  # resources :tabels
  #end
  #resources :monds do
  #  resources :tabels
  #end
  #resources   :tabels do
  #  resources :comments
  #end

  get 'welcome/index'
  #get 'levels/index'
  post 'welcome/index/:id', to: 'welcome#index', as: 'start'
  get 'monds/set_monat/:id', to: 'monds#set_monat', as: 'set_monat'
  post 'monds/index', to: 'monds#index', as: 'start_monds'

  #post 'tabels/time_index', to: 'tabels#time_index', as: 'tabels_time_index'
  #get 'tabels/time_show/:id', to: 'tabels#time_show', as: 'tabels_time_show'
  #get 'tabels/time_edit/:id', to: 'tabels#time_edit', as: 'tabels_time_edit'

  #get 'tabels/tab_index', to: 'tabels#tab_index', as: 'tabel_tab_index'
  #get 'tabels/tab_show', to: 'tabels#tab_show', as: 'tabel_tab_show'
  #get 'tabels/tab_edit', to: 'tabels#tab_edit', as: 'tabel_tab_edit'

  get 'comments/comments_show/:id', to: 'comments#comments_show', as: 'comments_show'

  #get 'comments/addcomment/:format', to: 'comments#addcomment', as: 'addcomment'
  #get 'levels/index/:id', to: 'levels#index', as: 'admin_levels'

  get "log_out" => "session#destroy", :as => "log_out"
  get "log_in" => "session#new",      :as => "log_in"
  get "sign_up" => "admins#new",       :as => "sign_up"
  #root :to => "users#new"
    #get 'persons/profile', as: 'user_root'

  root 'welcome#index'


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
