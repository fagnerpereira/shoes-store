Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'dashboard#index'
  get '/sales_by_stores', to: 'dashboard#sales_by_stores'
  get '/top_sales_by_stores', to: 'dashboard#top_sales_by_stores'
  get '/top_sales_by_products', to: 'dashboard#top_sales_by_products'

  resources :dashboard, only: :index
  resources :webhooks
end
