Rails.application.routes.draw do
  root "home#top"
  devise_for :users
  resources :posts
  post "images/upload_images", to: "images#upload_images"
end
