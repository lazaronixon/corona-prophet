Rails.application.routes.draw do

  namespace :dashboards do
    resources :states, only: :show
    get 'country', to: 'countries#show', as: :countries
  end

  get 'dashboards', to: 'dashboards#index'

  root 'dashboards#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
