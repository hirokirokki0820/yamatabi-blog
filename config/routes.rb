Rails.application.routes.draw do
  root "home#top"
  devise_for :users
  resources :posts
  post "images/upload_image", to: "images#upload_image"
  post "images/upload_image_from_media", to: "images#upload_image_from_media"
  post "images/delete_image", to: "images#delete_image"
end
