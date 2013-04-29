Tellme::Application.routes.draw do

  class OnlyAjaxRequest
    def matches?(request) 
      request.xhr?
    end
  end

  class OnlyHttpRequest
    def matches?(request) 
      !request.xhr?
    end
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  resources :dashboard

  constraints OnlyAjaxRequest.new do
    get 'month/:month/payments' => 'payments#by_month'
    
    resources :clients, only: [ :new, :edit, :cancel, :create, :update ] do
      collection do
        get :cancel
      end
      resources :invoices, only: [ :new ]
    end

    resources :invoices, only: [ :new, :show, :edit, :cancel, :create, :update ] do
      collection do
        get :cancel
      end
    end

    resources :payments, only: [:destroy] do
      member do
        put :mark
      end
    end
  end

  resources :clients, only: [:destroy ], constraints: OnlyHttpRequest.new

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
