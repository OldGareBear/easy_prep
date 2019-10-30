Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :courses do
    resources :students
    resources :test_assignments
  end

  resources :tests

  resources :users, only: [:edit, :show, :update]

  namespace :api do
    namespace :v1 do
      resources :skills, only: [:index]
    end
  end

  namespace :student do
    get 'dashboard', to: 'dashboard#show'

    resources :test_assignments
  end
end
