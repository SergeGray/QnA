Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, except: %i[index show], shallow: true do
      patch :select, on: :member
    end
  end

  root to: 'questions#index'
end
