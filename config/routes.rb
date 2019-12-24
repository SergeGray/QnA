Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, except: %i[index show], shallow: true
  end

  get 'answers/:id', to: 'answers#destroy', as: 'destroy_answer'

  root to: 'questions#index'
end
