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
    resources :test_assignments do
      post'grade' => 'test_assignments#grade'
    end
    resources :skills
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

    resources :test_assignments do
      post'submit' => 'test_assignments#submit'
    end
  end
end
