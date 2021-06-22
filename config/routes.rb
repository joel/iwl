# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root :to => "welcome#index"

  get 'welcome/index'

  concern :imageable do
    resources :images
  end
  resources :images
  resources :users, concerns: :imageable
  resources :posts
end
