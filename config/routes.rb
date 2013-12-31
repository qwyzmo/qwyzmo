QwyzmoApp::Application.routes.draw do
	resources :users
	resources :qwyzs
	resources :sessions,			:only => [:new, :create, :destroy]

	get		'/addqwyz',					to:	'qwyzs#add', as: 'add_qwyz'
	
	match '/signup',					to:	'users#new',				via: 'get'
  match '/signin',					to:	'sessions#new',			via: 'get'
  match '/signout',					to:	'sessions#destroy',	via: 'delete'
	
	get		'/signin',					to:	'sessions#new'
	get		'/signout',					to:	'sessions#destroy'
	root													'pages#home'
	
	get '/users/:id/edit_password', 	to: 'users#edit_password', 		as: 'edit_password'
	
	# get '/changepassword', 	to: 'users#change_password', 	as: 'change_password'
	# match '/change_status',	to: 'users#change_status', 		as: 'change_status', via: [:get, :post]
	
	# get '/contact',					to: 'pages#contact'
	# get '/about',						to: 'pages#about'
	# get '/help',						to: 'pages#help'

end
