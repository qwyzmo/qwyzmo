QwyzmoApp::Application.routes.draw do

	resources :users
	resources :qwyzs
	resources :sessions,			:only => [:new, :create, :destroy]

	# get		'/addqwyz',					to:	'qwyzs#add', as: 'add_qwyz'

  match '/signin',				to:	'sessions#new',					via: 	'get'
  match '/signout',				to:	'sessions#destroy',			via: 	'delete'
	
	match '/signup',				to:	'users#new',						via: 	'get'
	get 	'/editpass/:id',	to: 'users#edit_password', 	as: 	'editpass'
	get 	'/forgotpass',		to: 'users#forgot_password'
	get 	'/activate',			to: 'users#activate'
	get		'/testemail',			to: 'users#testemail'

	root										'pages#home'
end
