Rails.application.routes.draw do
  devise_for :users
  root to: "flats#index"
  get '/dashboard', to: 'pages#dashboard'

  resources :flats do
    resources :bookings, only: %i[new create destroy]
    resources :reviews, only: %i[new create]
  end

  resources :bookings, only: %i[index edit update]
end
