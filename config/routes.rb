QwyzmoApp::Application.routes.draw do
	#get "sessions/new"

	#get "users/new"
	
	resources :users
	resources :qwyzs
	resources :sessions,			:only => [:new, :create, :destroy]
	# resources :microposts,		:only => [:create, :destroy]
	
	get '/addqwyz',					to: 'qwyzs#add', as: 'add_qwyz'
	
	# get '/edit_password', 	to: 'users#edit_password', 		as: 'edit_password'
	# get '/changepassword', 	to: 'users#change_password', 	as: 'change_password'
	# match '/change_status',	to: 'users#change_status', 		as: 'change_status', via: [:get, :post]
	
	match '/signup',					to: 'users#new', via: 'get'
	
	get '/signin',					to: 'sessions#new'
	get '/signout',					to: 'sessions#destroy'
	root										    'pages#home'
	
	# get '/contact',					to: 'pages#contact'
	# get '/about',						to: 'pages#about'
	# get '/help',						to: 'pages#help'

end
