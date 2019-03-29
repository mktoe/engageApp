Rails.application.routes.draw do

	#devise
	devise_for :users
	devise_scope :user do
		get '/users/sign_out' => 'devise/sessions#destroy'
	end

	#profile scaffole
	resources :profiles
	
	#ompany_objectives
	resources :company_objectives
	
	post "posts/create" => "posts#create"
	get "posts/:id/edit" => "posts#edit"
	post "posts/:id/update" => "posts#update"
	post "posts/:id/destroy" => "posts#destroy"
	resources :posts

	#page Topページ
	root 'pages#index'

	#APIリクエストの処理
	namespace :api, { format: 'json' } do
		#posts　投稿
		resources :posts, only: [:index, :show, :create, :update, :destroy]
		#post_comments　投稿コメント
		resources :post_comments, only: [:index, :create, :update, :destroy]
		#post_likes いいね
		resources :post_likes, only: [:index, :create, :destroy]
		#プロフィール
		resources :profiles, only: [:index, :new, :create, :edit, :update, :destroy]
		#会社目標
		resources :company_objectives, only: [:index, :show, :create, :update, :destroy]
	end

end