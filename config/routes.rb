Rails.application.routes.draw do
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/cookies', to: 'static_pages#cookies'
  get '/contact', to: 'static_pages#contact'
  get '/newuser', to: 'static_pages#newuser'

  resources :invites, only: [:new, :create]
  
  resources :contacts, only: [:new, :create]
  get '/contacts', to: 'contacts#new'
  post '/your_endpoint', to: 'contacts#create'
  resources :ques_categories

  resources :questions do
    member do
      patch :make_unactive
    end
  end

  devise_for :users
  resources :future_messages do
    member do
      patch :publish 
    end
  end
  resources :future_message_alerts
  
  resources :questions do
    resources :answers
  end

  resources :young_people do
    resources :answers, only: [:index] 
    resources :future_messages, only: [:index]
  end

  resources :answers do
    delete :remove_media, on: :member
  end

  resources :questions do
    resources :change_requests, only: [:new, :create, :destroy, :index]
  end
  resources :change_requests, only: [:index, :show]

  resources :emotional_supports, only: [:new, :create, :index]
  resources :young_people
  resources :answer_alerts

  resources :bubbles
  resources :young_person_managements, param: :user_id do
    member do
      patch :passed_away
    end
  end

  resources :questions_controllers
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  
  resources :users do
    member do
      patch 'make_supporter_unactive'
      patch 'make_supporter_active'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :support, only: [:create]
      resources :questions, only: [:index, :show, :create, :update, :destroy]
      resources :change_requests, only: [:index, :show, :create, :destroy]
      resources :ques_categories, only: [:index, :show, :create, :destroy]
      resources :answers, only: [:index, :show, :create, :update, :destroy]
      resources :young_person_managements, only: [:index, :show]
      resources :bubbles, only: [:index, :show, :create, :update, :destroy] do
        resources :members, only: [:index, :show, :create, :update, :destroy]
        post 'assign', to: 'bubbles#assign'
        post 'unassign', to: 'bubbles#unassign'
      end
      resources :members, only: [:index, :show, :create, :update, :destroy]
    end
  end
  
  # Admin namespace for managing invites
  namespace :admin do
    resources :invites, only: [:index, :destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_scope :user do
    root to: "devise/sessions#new"
    # other Devise routes
  end
end

