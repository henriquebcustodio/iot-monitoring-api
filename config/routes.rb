Rails.application.routes.draw do
  post 'register', to: 'users/registrations#create'

  post 'login', to: 'users/sessions#create'

  get 'token', to: 'users/sessions#validate_token'

  resources :devices, only: %i[index show create update destroy] do
    resources :variables, only: %i[index create]
  end

  resources :variables, only: %i[show update destroy] do
    resources :data_points, only: %i[index create]
  end

  resources :data_points, only: %i[destroy]

  post 'broker/devices/authenticate', to: 'broker/devices/authorization#create'
end
