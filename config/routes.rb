Twitter::Application.routes.draw do
  root to: 'feed#index'

  devise_for :users
  resources :users, only: [:index, :show]

  resources :tweets, except: [:edit, :update] do
    resources :comments, only: :create
  end

  resources :friendships, except: [:new, :show] do
    collection do
      get :outgoing
      get :incoming
    end
  end
end
