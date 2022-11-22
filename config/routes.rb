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
    resources :users, only:[:show, :edit, :update]
    resources :posts, only:[:show, :edit, :update, :destroy]
    root to: "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
    get 'about' => 'homes#about'
    get '/download/:id', to: 'download#post_download', as: 'download' #投稿画像ダウンロード
    get 'search' => 'searches#search' #ワード検索

    resources :posts, only:[:new, :index, :show, :create, :edit, :destroy, :update] do
      resources :comments, only:[:create, :destroy] #コメント
      resource :favorites, only:[:create, :destroy] #いいね
    end

    resources :users, only:[:index, :show, :edit, :update] do
      resource :relationships, only:[:create,:destroy]
      get 'followings' => 'relationships#followings', as: 'followings' #フォロー
      get 'followers'  => 'relationships#followers' , as: 'followers' #フォロワー
      member do
         get :favorites #いいね一覧用
         get :followings #フォロー一覧用
         get :followers #フォロワー一覧用
      end
    end

    resources :tags do
      get "posts"=>"posts#search" #タグのリンク検索
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
