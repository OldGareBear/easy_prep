Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :courses do
    resources :students
  end

  resources :users, only: [:edit, :show, :update]
end
