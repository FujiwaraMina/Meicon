Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  devise_for :users,skip: [:passwords], controllers: {
    registrations:  "public/registrations",
    sessions:       "public/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  namespace :admin do
    resources :users, only:[:show,:edit,:update]
    resources :posts, only:[:show]
    root to: "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
    get 'about' => 'homes#about'

    resources :posts, only:[:index,:show,:create,:edit,:destroy,:update] do
      resources :comments, only:[:create] #コメント
      resource :favorites, only:[:create,:destroy] #いいね
    end

    resources :users, only:[:index,:show,:edit,:update] do
      resource :relationships, only:[:create,:destroy]
      get 'followings' => 'relationships#followings', as: 'followings' #フォロー
      get 'followers'  => 'relationships#followers' , as: 'followers' #フォロワー
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
