Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
  	post '/signup', to: 'registrations#create'
  	post '/login', to: 'sessions#create'
  	delete '/logout', to: 'sessions#destroy'
  	
  	namespace :api do
  		namespace :v1 do
  			resources :posts
  		end
  	end
  end
end
