Rails.application.routes.draw do
  root "posts#index"
  get "about", to: "home#about"

  # ユーザー
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/:id/profile", to: "users#show", as: 'users_profile'
  get "users/mypage", to: "users#mypage"

  # カテゴリー
  resources :categories, param: :permalink
  post "images/upload_image", to: "images#upload_image"
  post "images/delete_image", to: "images#delete_image"

  # 投稿
  resources :posts, only: [:index, :new], param: :permalink do
    collection do
      get "draft"
    end
  end
  get ":permalink", to: "posts#show", as: "post"
  post ":permalink", to: "posts#create"
  get ":permalink/edit", to: "posts#edit", as: "edit_post"
  patch ":permalink", to: "posts#update"
  put ":permalink", to: "posts#update"
  delete ":permalink", to: "posts#destroy"
end
