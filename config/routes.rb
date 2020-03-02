require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    registrations: 'registrations'
  }

  concern :votable do
    member do
      post :upvote, :downvote
      delete :cancel
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers,
              except: %i[index show],
              shallow: true,
              concerns: %i[votable commentable] do
      patch :select, on: :member
    end

    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :awards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
