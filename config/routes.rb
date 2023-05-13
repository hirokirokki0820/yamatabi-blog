Rails.application.routes.draw do
  root "posts#index"
  get "about", to: "home#about"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/:id/profile", to: "users#show", as: 'users_profile'
  get "users/mypage", to: "users#mypage"
  resources :posts do
    collection do
      get "draft"
    end
  end
  resources :categories
  post "images/upload_image", to: "images#upload_image"
  post "images/delete_image", to: "images#delete_image"
end
