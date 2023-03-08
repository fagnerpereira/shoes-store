Rails.application.routes.draw do
  resources :sales
  resources :products
  root 'dashboard#index'
  get '/sales_by_stores', to: 'dashboard#sales_by_stores'
  get '/top_sales_by_stores', to: 'dashboard#top_sales_by_stores'
  get '/top_sales_by_products', to: 'dashboard#top_sales_by_products'

  resources :stores
  resources :dashboard, only: :index
  resources :webhooks
end
