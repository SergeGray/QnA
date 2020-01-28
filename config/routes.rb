Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
      patch :select, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  root to: 'questions#index'
end
