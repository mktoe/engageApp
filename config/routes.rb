Rails.application.routes.draw do

	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html	

	#ompany_objectives
	resources :company_objectives
	namespace :api, { format: 'json' } do
		resources :company_objectives, only: [:index, :show, :create, :update, :destroy]
	end

	#devise
	devise_for :users
	devise_scope :user do
		get '/users/sign_out' => 'devise/sessions#destroy'
	end

	#page
	root 'pages#index'

	#profile scaffole
	resources :profiles
	#profile api
	namespace :api, { format: 'json' } do
		resources :profiles, only: [:index, :new, :create, :edit, :update, :destroy]
	end

	#posts
	post "posts/create" => "posts#create"
	get "posts/:id/edit" => "posts#edit"
	post "posts/:id/update" => "posts#update"
	post "posts/:id/destroy" => "posts#destroy"
	resources :posts
	namespace :api, { format: 'json' } do
		resources :posts, only: [:index, :show, :create, :update, :destroy]
	end

	#post_comments
	namespace :api, { format: 'json' } do
		resources :post_comments, only: [:index, :create, :update, :destroy]
	end

	#post_likes
	namespace :api, { format: 'json' } do
		resources :post_likes, only: [:index, :create, :destroy]
	end



	#post "post_comments/create" => "post_comments#create"
	#get "post_comments/:id/edit" => "post_comments#edit"
	#post "post_comments/:id/update" => "post_comments#update"
	#post "post_comments/:id/destroy" => "post_comments#destroy"	

	#get "post_likes/:post_id/create" => "post_likes#create"
	#get "post_likes/:post_id/destroy" => "post_likes#destroy"	

	

end