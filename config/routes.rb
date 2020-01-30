Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :upvote, :downvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, except: %i[index show], shallow: true do
      patch :select, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :awards, only: :index

  root to: 'questions#index'
end
