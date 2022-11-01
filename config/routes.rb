require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  post 'register', to: 'users/registrations#create'

  post 'login', to: 'users/sessions#create'

  get 'token', to: 'users/sessions#validate_token'

  resources :devices, only: %i[index show create update destroy], controller: 'devices' do
    resources :variables, only: %i[index create], controller: 'devices/variables'
  end

  resources :variables, only: %i[show update destroy], controller: 'devices/variables' do
    resources :data_points, only: %i[index create], controller: 'devices/variables/data_points'
  end

  resources :data_points, only: %i[destroy], controller: 'devices/variables/data_points'

  post 'broker/devices/authenticate', to: 'broker/devices/authorization#create'
end
