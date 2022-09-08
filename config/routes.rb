Rails.application.routes.draw do
  post 'register', to: 'users/registrations#create'

  post 'login', to: 'users/sessions#create'

  resources :devices, only: %i[create update]
end
