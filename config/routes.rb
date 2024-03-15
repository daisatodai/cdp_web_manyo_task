Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'tasks/search/sort_deadline_on', to: 'tasks#search', as: 'sort_deadline_on'
  # get 'tasks/search/sort_priority', to: 'tasks#search', as: 'sort_priority'
end
