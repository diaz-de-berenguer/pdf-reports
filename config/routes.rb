Rails.application.routes.draw do

	root 'reports#new'

	resources :reports, only: [:index, :new, :create]
	get 'report' => 'reports#show', defaults: { format: :pdf }

end
