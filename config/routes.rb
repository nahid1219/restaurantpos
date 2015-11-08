Gujmasala::Application.routes.draw do
  get "orders/close_store" => "orders#close_store",as: :close_store
  get "sessions/destroy" => "sessions#destroy",as: :log_out, via: :delete
  get "sessions/new" => "sessions#new",as: :sign_in
  get "users/new" => "users#new",as: :sign_up
  
  resources :users
  resources :sessions
  resources :admins
  resources :meals
  resources :tables
  resources :details
  resources :reports
  resources :deals
  resources :receivings
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
  root 'orders#new'
  #get "orders/receive_cash" => "orders#receive_cash",as: :receive_cash, via: :post
  #get 'orders/:id/cash' => 'orders#cash', as: :cash
  get 'orders/:id/bill' => 'orders#bill', as: :order_bill
  get 'orders/:id/close' => 'orders#close', as: :order_close
  resources :orders
  
end
