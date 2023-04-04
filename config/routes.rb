Rails.application.routes.draw do
  root "posts#index"
  get "profile", to: "home#profile"
  devise_for :users
  resources :posts
  resources :categories
  post "images/upload_image", to: "images#upload_image"
  post "images/upload_image_from_media", to: "images#upload_image_from_media"
  post "images/delete_image", to: "images#delete_image"
end
