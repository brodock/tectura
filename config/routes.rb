Tectura::Application.routes.draw do
  match '/session' => 'sessions#create', :as => :open_id_complete, :constraints => { :method => get }
  resources :sites
  resources :moderatorships
  resources :monitorships
  resources :topics do
  
  
      resources :posts
  end

  resources :posts
  resources :users do
  
    member do
  put :make_admin
  get :settings
  put :unsuspend
  delete :purge
  put :suspend
  end
  
  end

  match 'posts/:id/upvote' => 'votes#upvote', :as => :upvote
  match 'posts/:id/downvote' => 'votes#downvote', :as => :downvote
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => 
  match '/signup' => 'users#new', :as => :signup
  match '/state' => 'users#update_state', :as => :state
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/resend_confirmation_mail' => 'users#resend_confirmation_mail', :as => :resend_confirmation_mail
  match '/lost_password' => 'users#remember_password', :as => :lost_password
  match '/reset_password' => 'users#reset_password_confirmation', :as => :reset_password_confirmation, :via => post
  match '/reset_password/:secret' => 'users#reset_password', :as => :reset_password, :via => get
  match '/settings' => 'users#settings', :as => :settings
  resource :session
  match '/about' => 'about#show', :as => :about
  match '/bug_report' => 'about#bug_report', :as => :bug_report
  match '/tag/:tag_name' => 'tags#search', :as => :tag
  match '/search' => 'search#show', :as => :search
  match 'users/:user_id/monitored.:format' => 'posts#monitored', :as => :formatted_monitored_posts
  match 'users/:user_id/monitored' => 'posts#monitored', :as => :monitored_posts
  match 'forums/all' => 'forums#show_all', :as => :show_all
  match 'forums/voted' => 'forums#hide_downvoted', :as => :hide_downvoted
  match '/' => 'forums#show', :id => 'arquitetura'
end
