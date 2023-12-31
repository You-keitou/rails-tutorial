Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  # letter_opener
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only:[:edit]
  resources :password_resets, only:[:new, :create, :edit, :update]
  resources :microposts, only:[:create, :destroy]
end
