Rails.application.routes.draw do

	root 'reports#new'

	resources :reports

end
