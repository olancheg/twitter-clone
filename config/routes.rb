Twitter::Application.routes.draw do
  root to: 'feed#index'

  devise_for :users

  resources :tweets do
    resources :comments, only: :create
  end
  resources :users, only: [:index, :show]
end
