Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#show'

  namespace :api do
    post "/login", to: "users#login"
    get "/auto_login", to: "users#auto_login"
    resources :users
    resources :notes
  end

  resources :users do
    collection do
      get 'login_form'
      post 'login'
      delete 'logout'
    end
  end

  resources :notes
end
