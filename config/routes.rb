Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :labels, only: [:new, :create, :edit, :update, :destroy]
  namespace :admin do
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'tasks/search/sort_deadline_on', to: 'tasks#search', as: 'sort_deadline_on'
  # get 'tasks/search/sort_priority', to: 'tasks#search', as: 'sort_priority'
  get '/404', to: 'errors#not_found'
  # 500 Internal Server Errorエラーのカスタムルーティング
  get '/500', to: 'errors#internal_server_error'
end
