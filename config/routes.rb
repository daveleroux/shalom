Shalom::Application.routes.draw do
  get "person/new"


  #get "parties/new"

  #get "groups/new"

  #get "sessions/new"

  #get "users/new"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :groups

  #resources :parties, only: :index do
  #  match 'advanced_search' => 'users#advanced_search',
  #        on: :collection, via: [:get, :post], as: :advanced_search
  #end

  #resources :parties, only: :index do
  resources :parties do
    #resources :base_addresses
    #collection do
      match 'search' => 'parties#search',
            on: :collection, via: [:get, :post], :as => :search
    #end
  end


  #match '/signin',  :to => 'sessions#new'
  #match '/signout', :to => 'sessions#destroy'

  #match '/newuser',  :to => 'users#new'

  root :to => 'sessions#new'

  match '/people/new' => 'person#new', :as => :new_person, :via => :get
  #match '/people' => 'person#create', :via => :post
  match '/person/create' => 'person#create', :via => :post

  match '/parties/:id' => 'parties#add_to_group', :via => :post
  match '/parties/addressTypeChange' => 'parties#address_type_change', :via => :post
  match '/people/addSelectedToGroup' => 'parties#add_selected_to_group', :via => :post
  match '/people/deleteSelected' => 'parties#delete_selected', :via => :post
  match '/people/exportSelectedToExcel' => 'parties#export_selected_to_excel', :via => :post
  match '/people/import' => 'parties#import', :via => :post

  match 'groups/sms/:id' => 'groups#sms', :as => :sms_group, :via => :post
  match 'groups/:group_id/party/:party_id' => 'groups#remove_party', :as => :remove_party_from_group

end
