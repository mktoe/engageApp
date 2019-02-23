Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :profiles
  root 'pages#index'
  
  devise_for :users

  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"
  resources :posts

  post "post_comments/create" => "post_comments#create"
  get "post_comments/:id/edit" => "post_comments#edit"
  post "post_comments/:id/update" => "post_comments#update"
  post "post_comments/:id/destroy" => "post_comments#destroy"


  get "post_likes/:post_id/create" => "post_likes#create"
  get "post_likes/:post_id/destroy" => "post_likes#destroy"

end
