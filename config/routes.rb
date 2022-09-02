Rails.application.routes.draw do
  post 'register', to: 'users/registrations#create'
end
