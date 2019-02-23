Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :profiles
  root 'pages#index'
  
  devise_for :users

  post "posts/create" => "posts#create"

  post "post_comments/create" => "post_comments#create"

  get "post_likes/:post_id/create" => "post_likes#create"
  get "post_likes/:post_id/destroy" => "post_likes#destroy"

  

  
  
end
