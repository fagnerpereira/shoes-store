Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'dashboard#index'
  get '/sales_by_stores', to: 'dashboard#sales_by_stores'
  resources :webhooks
end
