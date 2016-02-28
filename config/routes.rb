Rails.application.routes.draw do

  mount_devise_token_auth_for 'Recruiter', at: 'recruiter_auth', controllers: {
    registrations: 'api/v1/overrides/recruiter/registrations' , 
    sessions: 'api/v1/overrides/recruiter/sessions'
  }

  mount_devise_token_auth_for 'Applicant', at: 'applicant_auth' , controllers: {
    registrations: 'api/v1/overrides/applicant/registrations'
    #sessions: 'api/v1/overrides/applicant/sessions'
  }
  
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

  api_routes = lambda do
    namespace :recruiter do
      resources :jobs , only: [:index , :show , :create , :update , :destroy]
      resources :departments , only: [:index , :show , :create , :update]
      resources :job_applications , only: [:index , :update , :show]
      resources :profile , only: [:index] do
        post '' , action: :update , on: :collection , as: :update
      end 
    end

    resources :jobs , only: [:index , :show]
    resources :job_applications , only: [:index , :create , :show]
    resources :profile , only: [:index] do
      post '' , action: :update , on: :collection , as: :update
    end
end

    namespace :api do
    namespace :v1 , &api_routes
  end

end
