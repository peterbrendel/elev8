# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :sessions, only: [:create]

    resource :user, controller: 'users', only: [:create] do
      resources :game_events, only: [:create], shallow: true
    end

    # post 'user/game_events', to: 'game_events#create'
  end
end
