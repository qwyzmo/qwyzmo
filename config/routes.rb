QwyzmoApp::Application.routes.draw do
	get '/users/check_email', 				to: 'users#check_email',			as: 'check_email'

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

end
