QwyzmoApp::Application.routes.draw do

	resources :users
	resources :qwyzs
	resources :sessions,			:only => [:new, :create, :destroy]

	# get		'/addqwyz',					to:	'qwyzs#add', as: 'add_qwyz'

  match '/signin',				to:	'sessions#new',					via: 	'get'
  match '/signout',				to:	'sessions#destroy',			via: 	'delete'
	
	match '/signup',				to:	'users#new',						via: 	'get'
	
	# TODO refactor these into restful resources
	get 	'/editpass/:id',	to: 'users#edit_password', 	as: 	'editpass'
	get 	'/activate',			to: 'users#activate'
		
	# #####################  password change routes
	# enter email for reset
	get 	'/forgot_password',		to: 'users#forgot_password'
	# send link with pass token
	get 	'/send_reset_link',	to: 'users#send_reset_link'
	# enter uname and new pass
	get		'/get_reset_password',	to: 'users#get_reset_password'
	# reset the password
	post	'/reset_pass', 		to: 'users#reset_password'

	# This route is for testing email sending only
	# get		'/testemail',			to: 'users#testemail'

	root										'pages#home'
end
