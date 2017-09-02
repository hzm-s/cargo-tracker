Rails.application.routes.draw do
  resources :cargo_bookings, only: [:new]

  root to: 'home#index'
end
