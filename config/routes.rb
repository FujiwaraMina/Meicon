Rails.application.routes.draw do
  namespace :admin do
    resources :users, only:[:show,:edit]
    resources :posts, only:[:show]
    root to: "homes#top"
  end

  namespace :public do
    root to: "homes#top"
    get 'homes/about'

    resources :posts, only:[:index,:show,:create,:edit,:destroy,:update] do
      resources :comments, only:[:create] #コメント
      resource :favorites, only:[:create,:destroy] #いいね
    end

    resources :users, only:[:index,:show,:edit] do
      resource :relationships, only:[:create,:destroy]
      get 'followings' => 'relationships#followings', as: 'followings' #フォロー
      get 'followers'  => 'relationships#followers' , as: 'followers' #フォロワー
    end
  end

  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
