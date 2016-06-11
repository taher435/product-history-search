Rails.application.routes.draw do

  root 'product_histories#index'

  post 'product-history' => 'product_histories#create'
  get 'product-history/search' => 'product_histories#search'

  resources :product_histories
end
