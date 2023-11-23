Rails.application.routes.draw do
  resources :mining_types
  root "wellcome#index"
  resources :coins
end
