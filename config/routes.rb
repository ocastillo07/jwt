Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
  	post '/signup', to: 'registrations#create'
  	post '/login', to: 'sessions#create'
  	delete '/logout', to: 'sessions#destroy'
  end
end
