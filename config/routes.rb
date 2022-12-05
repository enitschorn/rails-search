Rails.application.routes.draw do
  devise_for :users
  root to: "pages#index"

  resources :flats do
    resources :bookings, only: %i[new create destroy]
  end

  resources :bookings, only: %i[index]
end
