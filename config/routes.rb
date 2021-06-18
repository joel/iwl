# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  concern :imageable do
    resources :images
  end
  resources :images
  resources :users, concerns: :imageable
  resources :posts
end
