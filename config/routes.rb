# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :products, only: :index do
    collection { get 'search', to: 'products#search' }
  end
end
