Rails.application.routes.draw do
  resources :csv_objects, except: [:update, :destroy, :show]
  resources :job_status, only: [:show]

  root to: 'csv_objects#new'
end
