Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

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
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :awards, only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
