QwyzmoApp::Application.routes.draw do

	resources :users
	resources :qwyzs
	resources :qwyz_items
	resources :sessions,			:only => [:new, :create, :destroy]

  match '/signin',				to:	'sessions#new',					via: 	'get'
  match '/signout',				to:	'sessions#destroy',			via: 	[:delete, :get]
	
	match '/signup',				to:	'users#new',						via: 	'get'
	
	get 	'/editpass/:id',	to: 'users#edit_password', 	as: 	'editpass'
	get 	'/activate',			to: 'users#activate'
		
	# #####################  password change routes
	# get email for pass reset
	get 	'/forgot_password',		to: 'users#forgot_password'
	
	# send link with pass token
	get		'/send_reset_link',	to: 'users#send_reset_link'
	
	# enter uname and new pass									
	get		'/get_reset_password',	to: 'users#get_reset_password'

	# reset the password
	match	'/reset_pass', 		to: 'users#reset_password', via: [:patch,:post]

	get 	'/inactive_qwyz_items/:id',	to: 'qwyzs#show_inactive_qwyz_items',
				as: 'inactive_qwyz_items'
				
	post	'/activate_item/:id', 			to: 'qwyz_items#activate'

	root										'pages#home'
end
